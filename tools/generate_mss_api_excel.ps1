param(
    [string]$OutputPath = "docs\MSS_Mobile_API_Implementation_Plan.xlsx"
)

$ErrorActionPreference = "Stop"

function XmlEscape([object]$Value) {
    if ($null -eq $Value) { return "" }
    return [System.Security.SecurityElement]::Escape([string]$Value)
}

function ColumnName([int]$Index) {
    $name = ""
    while ($Index -gt 0) {
        $Index--
        $name = [char](65 + ($Index % 26)) + $name
        $Index = [math]::Floor($Index / 26)
    }
    return $name
}

function WorksheetXml($Rows, $Widths) {
    $rowCount = $Rows.Count
    $columnCount = $Rows[0].Count
    $lastCell = "$(ColumnName $columnCount)$rowCount"
    $columns = for ($i = 0; $i -lt $Widths.Count; $i++) {
        $index = $i + 1
        "<col min=`"$index`" max=`"$index`" width=`"$($Widths[$i])`" customWidth=`"1`"/>"
    }
    $xmlRows = for ($r = 0; $r -lt $rowCount; $r++) {
        $cells = for ($c = 0; $c -lt $columnCount; $c++) {
            $reference = "$(ColumnName ($c + 1))$($r + 1)"
            $style = if ($r -eq 0) { 1 } else { 2 }
            $value = XmlEscape $Rows[$r][$c]
            "<c r=`"$reference`" s=`"$style`" t=`"inlineStr`"><is><t xml:space=`"preserve`">$value</t></is></c>"
        }
        "<row r=`"$($r + 1)`">$($cells -join '')</row>"
    }
    return @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <dimension ref="A1:$lastCell"/>
  <sheetViews><sheetView workbookViewId="0"><pane ySplit="1" topLeftCell="A2" activePane="bottomLeft" state="frozen"/></sheetView></sheetViews>
  <sheetFormatPr defaultRowHeight="18"/>
  <cols>$($columns -join '')</cols>
  <sheetData>$($xmlRows -join '')</sheetData>
  <autoFilter ref="A1:$lastCell"/>
</worksheet>
"@
}

function AddZipEntry($Zip, [string]$Name, [string]$Content) {
    $entry = $Zip.CreateEntry($Name, [System.IO.Compression.CompressionLevel]::Optimal)
    $stream = $entry.Open()
    $utf8 = [System.Text.UTF8Encoding]::new($false)
    $writer = [System.IO.StreamWriter]::new($stream, $utf8)
    $writer.Write($Content.TrimStart())
    $writer.Dispose()
    $stream.Dispose()
}

$inventory = @(
    @("API ID", "Module", "Method", "Endpoint", "Purpose / Kaam", "When Hit / Kab Call Hogi", "Primary Data Source", "Cache Rule", "Security Validation", "Status", "Priority"),
    @("CTX-01", "MSS Context", "GET", "/ermobile/api/mss/v1/context", "Active panel, profile, organisation and module permissions return karegi.", "MSS/MSS_MO landing; profile switch; organisation switch; permission version change; expired context on app resume.", "Mobile session DB + synced profile/permission data", "Memory + SharedPreferences per profile/organisation; invalidate on version or selection change.", "JWT, mobile session, profile ownership, organisation scope", "Planned", "P0"),
    @("ORG-01", "Organisation", "POST", "/ermobile/api/mss/v1/organisations", "MSS_MO parent ke allowed child organisations return karegi. Single MSS ke liye list call nahi hogi.", "Login/context setup only for MSS_MO; organisation selector refresh.", "R2 organisation hierarchy through mobile BFF", "30-second memory cache; persist active selection only.", "MSS_MO profile and parent-child scope", "Implemented", "P0"),
    @("FLT-01", "Filter Metadata", "GET", "/ermobile/api/mss/v1/approval-filters", "Request types, approval levels/stages and branches provide karegi.", "First approval page open; organisation/module change; cache version/TTL expiry; manual refresh.", "R3 request catalog + R3 workflow + mobile synced branch DB", "Memory + SharedPreferences key approvalFilters:{orgId}:{module}; stale-while-refresh.", "JWT, session, active profile, organisation access", "Implemented - version/TTL enhancement planned", "P0"),
    @("DSH-01", "Dashboard", "GET", "/ermobile/api/mss/v1/dashboard", "Team dashboard counts and permission-aware quick actions return karegi.", "Team dashboard enter; pull-to-refresh; profile/organisation switch; successful approval action.", "R3 approval inbox aggregate + mobile permission context", "Short memory cache 30-60 seconds, scoped by profile/org.", "MSS/MSS_MO profile and module permissions", "Planned", "P0"),
    @("APR-ATT-01", "Attendance Approval", "GET", "/ermobile/api/mss/v1/requisitions", "Attendance pending/actioned approval list with summary and pagination.", "Attendance card/quick action; filter/search/tab/page change; refresh.", "R3 approval workflow inbox", "No persistent list cache; optional current-page memory cache.", "Attendance view permission + approver assignment", "Planned", "P0"),
    @("APR-LEV-01", "Leave Approval", "GET", "/ermobile/api/mss/v1/requisitions", "Leave pending/actioned approval list with summary and pagination.", "Leave card/quick action; filter/search/tab/page change; refresh.", "R3 approval workflow inbox + leave domain", "No persistent list cache; optional current-page memory cache.", "Leave view permission + approver assignment", "Planned", "P0"),
    @("APR-OD-01", "OD Approval", "GET", "/ermobile/api/mss/v1/requisitions", "On Duty pending/actioned approval list with summary and pagination.", "OD card/quick action; filter/search/tab/page change; refresh.", "R3 approval workflow inbox + OD domain", "No persistent list cache; optional current-page memory cache.", "OD view permission + approver assignment", "Planned", "P0"),
    @("APR-WFH-01", "WFH Approval", "GET", "/ermobile/api/mss/v1/requisitions", "Work From Home pending/actioned approval list.", "WFH card/quick action; filter/search/tab/page change; refresh.", "R3 approval workflow inbox", "No persistent list cache.", "WFH view permission + approver assignment", "Planned", "P0"),
    @("APR-CMP-01", "Comp Off Approval", "GET", "/ermobile/api/mss/v1/requisitions", "Comp Off pending/actioned approval list.", "Comp Off card/quick action; filter/search/tab/page change; refresh.", "R3 approval workflow inbox + leave ledger domain", "No persistent list cache.", "Comp Off view permission + approver assignment", "Planned", "P0"),
    @("APR-DTL-01", "Approval Common", "GET", "/ermobile/api/mss/v1/requisitions/{requestId}", "Selected requisition ki complete employee, request, stage, approver and action details.", "Any requisition list item Review/Details click.", "R3 workflow + relevant Attendance/Leave/OD/WFH/Comp Off domain", "Memory only during detail session.", "Request organisation/profile scope + current approver visibility", "Planned", "P0"),
    @("APR-DEC-01", "Approval Common", "POST", "/ermobile/api/mss/v1/requisitions/{requestId}/decision", "Attendance, Leave, OD, WFH and Comp Off approve/reject/send-back/forward action.", "Detail page action confirmation.", "R3 workflow decision service", "Never cache; invalidate dashboard/list/detail after success.", "Action permission, current pending level, optimistic locking/idempotency", "Planned", "P0"),
    @("APR-HIS-01", "Approval Common", "GET", "/ermobile/api/mss/v1/requisitions/{requestId}/history", "L1/L2/L3 approval timeline, approvers, remarks and timestamps.", "Detail page History section open or detail payload lazy-load.", "R3 workflow stages/audit", "Memory cache until request action changes.", "Request visibility permission", "Planned", "P1"),
    @("APR-ATTCH-01", "Approval Common", "GET", "/ermobile/api/mss/v1/requisitions/{requestId}/attachments/{attachmentId}", "Secure attachment preview/download without exposing internal file path.", "User attachment click.", "R3/R2 document storage through mobile BFF", "HTTP cache headers where safe; no SharedPreferences payload.", "Request visibility + attachment ownership", "Planned", "P1"),
    @("APR-BULK-01", "Approval Common", "POST", "/ermobile/api/mss/v1/requisitions/bulk-decision", "Selected requisitions ka bulk approve/reject.", "Future bulk-selection confirmation only.", "R3 workflow decision service", "Never cache.", "Every request independently validated; idempotency", "Future", "P2"),
    @("TEAM-SUM-01", "My Team", "GET", "/ermobile/api/mss/v1/team/summary", "Team strength, present, absent, leave, OD, joiner and exit summary.", "People/My Team landing; refresh; profile/organisation change.", "Mobile synced employee DB + R3 attendance summary", "30-60 second profile/org scoped cache.", "Team hierarchy and profile scope", "Planned", "P1"),
    @("TEAM-LST-01", "My Team", "GET", "/ermobile/api/mss/v1/team/employees", "Reporting hierarchy ke allowed employees ki paginated list.", "Employees/My Team screen; search/filter/page change.", "Mobile synced employee/manager DB", "Current-page memory cache only.", "Profile permission + reporting hierarchy + organisation", "Planned", "P1"),
    @("TEAM-DTL-01", "My Team", "GET", "/ermobile/api/mss/v1/team/employees/{employeeId}", "Selected employee profile, reporting and employment details.", "Employee list item click.", "Mobile synced employee DB + R2 profile where required", "Short memory cache.", "Employee must be in allowed team scope", "Planned", "P1"),
    @("TEAM-ATT-01", "My Team", "GET", "/ermobile/api/mss/v1/team/employees/{employeeId}/attendance-summary", "Selected employee ka attendance summary.", "Employee detail Attendance section open/date range change.", "R3 attendance service", "Date-range scoped short cache.", "Employee team scope + attendance view permission", "Planned", "P2"),
    @("IND-SUM-01", "Induction", "GET", "/ermobile/api/mss/v1/induction/summary", "Induction/open onboarding counts.", "Induction landing; refresh; profile/organisation change.", "R2/R3 induction domain", "30-60 second scoped cache.", "Induction view permission", "Planned", "P1"),
    @("IND-LST-01", "Induction", "GET", "/ermobile/api/mss/v1/induction/employees", "Induction employees/candidates paginated list.", "Induction list open; filter/search/page change.", "R2/R3 induction domain", "Current-page memory cache only.", "Induction view permission + organisation scope", "Planned", "P1"),
    @("IND-DTL-01", "Induction", "GET", "/ermobile/api/mss/v1/induction/employees/{inductionId}", "Candidate/employee induction details, documents and stages.", "Induction list item click.", "R2/R3 induction domain", "Short memory cache.", "Induction request visibility", "Planned", "P1"),
    @("IND-ACT-01", "Induction", "POST", "/ermobile/api/mss/v1/induction/employees/{inductionId}/action", "Induction approve/reject/complete stage action.", "Induction detail action confirmation.", "R2/R3 induction workflow", "Never cache; invalidate induction summary/list/detail.", "Induction action permission and current stage", "Planned", "P1"),
    @("EXT-SUM-01", "Exit Employee", "GET", "/ermobile/api/mss/v1/exits/summary", "Pending exit, notice, clearance and completed exit counts.", "Exit landing; refresh; profile/organisation change.", "R2/R3 exit domain", "30-60 second scoped cache.", "Exit view permission", "Planned", "P1"),
    @("EXT-LST-01", "Exit Employee", "GET", "/ermobile/api/mss/v1/exits/employees", "Exit/resignation employees paginated list.", "Exit list open; filter/search/page change.", "R2/R3 exit domain", "Current-page memory cache only.", "Exit view permission + organisation/team scope", "Planned", "P1"),
    @("EXT-DTL-01", "Exit Employee", "GET", "/ermobile/api/mss/v1/exits/employees/{exitRequestId}", "Resignation, notice period, LWD, clearance, documents and history.", "Exit employee list item click.", "R2/R3 exit domain", "Short memory cache.", "Exit request visibility", "Planned", "P1"),
    @("EXT-DEC-01", "Exit Employee", "POST", "/ermobile/api/mss/v1/exits/employees/{exitRequestId}/decision", "Exit request approve/reject/send-back action.", "Exit detail action confirmation.", "R2/R3 exit workflow", "Never cache; invalidate exit summary/list/detail.", "Exit action permission and current level", "Planned", "P1")
)

$parameters = @(
    @("API ID", "Parameter", "Location", "Type", "Required", "Allowed / Example", "Description"),
    @("ALL", "Authorization", "Header", "String", "Yes", "Bearer <accessToken>", "JWT access token."),
    @("ALL", "X-Mobile-Session-Id", "Header", "String", "Yes", "mobile session UUID", "Active mobile session validation."),
    @("ALL", "X-Request-ID", "Header", "String", "Recommended", "UUID", "Tracing; write APIs me idempotency correlation."),
    @("ORG-01", "activePanel", "Body", "String", "Yes", "MSS_MO", "Only MSS_MO organisation listing allow hogi."),
    @("ORG-01", "profileId", "Body", "Long", "Yes", "10", "Selected MSS_MO profile."),
    @("CTX-01", "organisationId", "Query", "Long", "No", "15", "Absent ho to active session organisation use hogi."),
    @("CTX-01", "profileId", "Query", "Long", "No", "10", "Absent ho to active profile use hoga."),
    @("FLT-01", "organisationId", "Query", "Long", "Yes", "15", "Selected organisation ke branches/workflow stages."),
    @("FLT-01", "moduleCode", "Query", "String", "No", "TIME_ATTENDANCE / LEAVE / OD / WFH / COMP_OFF", "Omit karne par all approval filter groups return kiye ja sakte hain."),
    @("DSH-01", "organisationId", "Query", "Long", "Yes", "15", "Selected MSS/MSS_MO organisation."),
    @("DSH-01", "profileId", "Query", "Long", "Yes", "10", "Counts selected profile permissions/assignments ke according."),
    @("APR-ATT-01", "module", "Query", "Enum", "Yes", "ATTENDANCE", "Attendance approval list discriminator."),
    @("APR-LEV-01", "module", "Query", "Enum", "Yes", "LEAVE", "Leave approval list discriminator."),
    @("APR-OD-01", "module", "Query", "Enum", "Yes", "OD", "OD approval list discriminator."),
    @("APR-WFH-01", "module", "Query", "Enum", "Yes", "WFH", "WFH approval list discriminator."),
    @("APR-CMP-01", "module", "Query", "Enum", "Yes", "COMP_OFF", "Comp Off approval list discriminator."),
    @("APR-*-01", "organisationId", "Query", "Long", "Yes", "15", "Selected organisation."),
    @("APR-*-01", "profileId", "Query", "Long", "Yes", "10", "Selected profile."),
    @("APR-*-01", "tab", "Query", "Enum", "No", "PENDING / ACTIONED", "Pending with me or actioned by me."),
    @("APR-*-01", "requestType", "Query", "String", "No", "REGULARIZATION", "Request catalog filter."),
    @("APR-*-01", "stage", "Query", "Integer", "No", "1", "Current approval level filter."),
    @("APR-*-01", "branchId", "Query", "Long", "No", "25", "Synced branch filter."),
    @("APR-*-01", "search", "Query", "String", "No", "Ankur / EMP101", "Employee name, code or department search."),
    @("APR-*-01", "fromDate", "Query", "Date", "No", "2026-08-01", "Applied/requested date range start."),
    @("APR-*-01", "toDate", "Query", "Date", "No", "2026-08-31", "Applied/requested date range end."),
    @("LIST APIs", "page", "Query", "Integer", "No", "0", "Zero-based page number."),
    @("LIST APIs", "size", "Query", "Integer", "No", "20", "Page size; enforce backend maximum."),
    @("LIST APIs", "sort", "Query", "String", "No", "STAGE_PRIORITY / NEWEST", "Supported server-side sorting."),
    @("APR-DTL-01", "requestId", "Path", "Long/String", "Yes", "REQ-1001", "Unique approval request identifier."),
    @("APR-DTL-01", "module", "Query", "Enum", "Yes", "ATTENDANCE / LEAVE / OD / WFH / COMP_OFF", "Correct domain details resolve karega."),
    @("APR-DEC-01", "decision", "Body", "Enum", "Yes", "APPROVE / REJECT / SEND_BACK / FORWARD", "Approval action."),
    @("APR-DEC-01", "remarks", "Body", "String", "Conditional", "Approved", "Reject/send-back par mandatory kar sakte hain."),
    @("APR-DEC-01", "version", "Body", "Long", "Recommended", "3", "Optimistic locking; stale decision prevent karega."),
    @("APR-DEC-01", "clientActionId", "Body", "UUID", "Yes", "UUID", "Duplicate approval submission prevent karega."),
    @("TEAM-LST-01", "branchId", "Query", "Long", "No", "25", "Team branch filter."),
    @("TEAM-LST-01", "departmentId", "Query", "Long", "No", "8", "Team department filter."),
    @("TEAM-LST-01", "status", "Query", "String", "No", "ACTIVE", "Employment status filter."),
    @("TEAM-LST-01", "search", "Query", "String", "No", "EMP101", "Employee search."),
    @("TEAM-DTL-01", "employeeId", "Path", "Long", "Yes", "10105", "Allowed team employee."),
    @("TEAM-ATT-01", "fromDate/toDate", "Query", "Date", "No", "2026-08-01 / 2026-08-31", "Attendance summary range."),
    @("IND-LST-01", "stage", "Query", "String", "No", "DOCUMENT_VERIFICATION", "Induction stage filter."),
    @("IND-LST-01", "status", "Query", "String", "No", "PENDING", "Induction status filter."),
    @("IND-ACT-01", "action", "Body", "Enum", "Yes", "APPROVE / REJECT / COMPLETE", "Induction workflow action."),
    @("IND-ACT-01", "remarks", "Body", "String", "Conditional", "Documents verified", "Action remarks."),
    @("EXT-LST-01", "departmentId/branchId", "Query", "Long", "No", "8 / 25", "Exit employee filters."),
    @("EXT-LST-01", "stage", "Query", "String", "No", "MANAGER_APPROVAL", "Exit workflow stage."),
    @("EXT-LST-01", "status", "Query", "String", "No", "PENDING", "Exit request status."),
    @("EXT-DEC-01", "decision", "Body", "Enum", "Yes", "APPROVE / REJECT / SEND_BACK", "Exit decision."),
    @("EXT-DEC-01", "remarks", "Body", "String", "Conditional", "Approved", "Decision remarks.")
)

$callFlow = @(
    @("Event / Screen", "Step", "API ID", "API Call", "Expected Behaviour"),
    @("Fresh login with ESS permission", "1", "CTX-01", "No immediate MSS context call", "ESS default active rahega; MSS API only profile select par."),
    @("Fresh login without ESS permission", "1", "CTX-01", "GET context after first profile becomes active", "First MSS/MSS_MO profile and its organisation/permissions resolve honge."),
    @("ESS to MSS profile switch", "1", "CTX-01", "GET context", "Old ESS context replace; only selected profile active."),
    @("MSS profile switch", "1", "CTX-01", "GET context", "Profile permissions and active organisation reset/resolve."),
    @("MSS_MO profile selected", "2", "ORG-01", "POST organisations", "Allowed child organisation selector populate."),
    @("Organisation changed", "1", "CTX-01", "GET context", "New organisation permissions/context validate."),
    @("Organisation changed", "2", "FLT-01", "GET filters", "New branches and workflow stages load; old org cache not reused."),
    @("Team dashboard open", "1", "DSH-01", "GET dashboard", "Summary counts and quick actions load."),
    @("Attendance card click", "1", "APR-ATT-01", "GET requisitions?module=ATTENDANCE", "Attendance list first page load."),
    @("Leave card click", "1", "APR-LEV-01", "GET requisitions?module=LEAVE", "Leave list first page load."),
    @("OD card click", "1", "APR-OD-01", "GET requisitions?module=OD", "OD list first page load."),
    @("WFH card click", "1", "APR-WFH-01", "GET requisitions?module=WFH", "WFH list first page load."),
    @("Comp Off card click", "1", "APR-CMP-01", "GET requisitions?module=COMP_OFF", "Comp Off list first page load."),
    @("First approval page in org/module", "1", "FLT-01", "GET filters only if cache missing/stale", "Cached filters immediately show, background refresh when required."),
    @("Filter/search/tab/page changed", "1", "APR-*-01", "GET requisitions with query", "Server-filtered paginated list and summary update."),
    @("Review clicked", "1", "APR-DTL-01", "GET requisition details", "Complete domain and workflow details show."),
    @("History expanded", "1", "APR-HIS-01", "GET history if not included/cached", "Approval timeline load."),
    @("Approve/reject confirmed", "1", "APR-DEC-01", "POST decision", "Action validated and persisted once."),
    @("Approve/reject success", "2", "DSH-01 + APR-*-01", "Refresh dashboard and current list", "Counts/order/list update; detail cache invalidate."),
    @("My Team tab open", "1", "TEAM-SUM-01", "GET team summary", "Team KPIs load."),
    @("Employee list open", "1", "TEAM-LST-01", "GET team employees", "Allowed hierarchy list load."),
    @("Employee clicked", "1", "TEAM-DTL-01", "GET employee details", "Selected employee detail load."),
    @("Induction tab open", "1", "IND-SUM-01 + IND-LST-01", "GET summary and first page", "Induction counts/list load."),
    @("Exit tab open", "1", "EXT-SUM-01 + EXT-LST-01", "GET summary and first page", "Exit counts/list load.")
)

$approvalCoverage = @(
    @("Approval Module", "List API", "Detail API", "Decision API", "History API", "Attachment API", "Dashboard Count", "Filters", "Coverage"),
    @("Attendance", "APR-ATT-01 module=ATTENDANCE", "APR-DTL-01 module=ATTENDANCE", "APR-DEC-01 module=ATTENDANCE", "APR-HIS-01", "APR-ATTCH-01", "DSH-01 attendance", "ATTENDANCE family + stage + branch", "Included"),
    @("Leave", "APR-LEV-01 module=LEAVE", "APR-DTL-01 module=LEAVE", "APR-DEC-01 module=LEAVE", "APR-HIS-01", "APR-ATTCH-01", "DSH-01 leave", "LEAVE family + stage + branch", "Included"),
    @("On Duty (OD)", "APR-OD-01 module=OD", "APR-DTL-01 module=OD", "APR-DEC-01 module=OD", "APR-HIS-01", "APR-ATTCH-01", "DSH-01 od", "OD family + stage + branch", "Included"),
    @("Work From Home", "APR-WFH-01 module=WFH", "APR-DTL-01 module=WFH", "APR-DEC-01 module=WFH", "APR-HIS-01", "APR-ATTCH-01", "DSH-01 wfh", "WFH type + stage + branch", "Included"),
    @("Comp Off", "APR-CMP-01 module=COMP_OFF", "APR-DTL-01 module=COMP_OFF", "APR-DEC-01 module=COMP_OFF", "APR-HIS-01", "APR-ATTCH-01", "DSH-01 compOff", "COMP_OFF type + stage + branch", "Included")
)

$output = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $OutputPath))
$outputDirectory = [System.IO.Path]::GetDirectoryName($output)
[System.IO.Directory]::CreateDirectory($outputDirectory) | Out-Null
if ([System.IO.File]::Exists($output)) { [System.IO.File]::Delete($output) }

Add-Type -AssemblyName System.IO.Compression
$fileStream = [System.IO.File]::Open($output, [System.IO.FileMode]::CreateNew)
$zip = New-Object System.IO.Compression.ZipArchive($fileStream, [System.IO.Compression.ZipArchiveMode]::Create)

$contentTypes = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/worksheets/sheet3.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/worksheets/sheet4.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
</Types>
"@
$rootRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
"@
$workbook = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="API Inventory" sheetId="1" r:id="rId1"/>
    <sheet name="Parameters" sheetId="2" r:id="rId2"/>
    <sheet name="Call Flow" sheetId="3" r:id="rId3"/>
    <sheet name="Approval Coverage" sheetId="4" r:id="rId4"/>
  </sheets>
</workbook>
"@
$workbookRels = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet3.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet4.xml"/>
  <Relationship Id="rId5" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
</Relationships>
"@
$styles = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
  <fonts count="2"><font><sz val="10"/><name val="Calibri"/></font><font><b/><color rgb="FFFFFFFF"/><sz val="10"/><name val="Calibri"/></font></fonts>
  <fills count="3"><fill><patternFill patternType="none"/></fill><fill><patternFill patternType="gray125"/></fill><fill><patternFill patternType="solid"><fgColor rgb="FF185FA5"/><bgColor indexed="64"/></patternFill></fill></fills>
  <borders count="2"><border/><border><left style="thin"><color rgb="FFD9E2F3"/></left><right style="thin"><color rgb="FFD9E2F3"/></right><top style="thin"><color rgb="FFD9E2F3"/></top><bottom style="thin"><color rgb="FFD9E2F3"/></bottom></border></borders>
  <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
  <cellXfs count="3"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/><xf numFmtId="0" fontId="1" fillId="2" borderId="1" xfId="0" applyAlignment="1"><alignment horizontal="center" vertical="center" wrapText="1"/></xf><xf numFmtId="0" fontId="0" fillId="0" borderId="1" xfId="0" applyAlignment="1"><alignment vertical="top" wrapText="1"/></xf></cellXfs>
  <cellStyles count="1"><cellStyle name="Normal" xfId="0" builtinId="0"/></cellStyles>
</styleSheet>
"@

AddZipEntry $zip "[Content_Types].xml" $contentTypes
AddZipEntry $zip "_rels/.rels" $rootRels
AddZipEntry $zip "xl/workbook.xml" $workbook
AddZipEntry $zip "xl/_rels/workbook.xml.rels" $workbookRels
AddZipEntry $zip "xl/styles.xml" $styles
AddZipEntry $zip "xl/worksheets/sheet1.xml" (WorksheetXml $inventory @(14, 20, 10, 48, 50, 58, 38, 45, 42, 25, 10))
AddZipEntry $zip "xl/worksheets/sheet2.xml" (WorksheetXml $parameters @(16, 25, 14, 14, 12, 42, 60))
AddZipEntry $zip "xl/worksheets/sheet3.xml" (WorksheetXml $callFlow @(35, 10, 20, 48, 70))
AddZipEntry $zip "xl/worksheets/sheet4.xml" (WorksheetXml $approvalCoverage @(24, 32, 32, 32, 22, 24, 20, 38, 14))

$zip.Dispose()
$fileStream.Dispose()
Write-Output $output
