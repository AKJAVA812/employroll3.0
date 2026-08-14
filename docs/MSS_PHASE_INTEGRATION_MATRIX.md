# MSS Phase Integration Matrix

This matrix records the mobile backend and Flutter integration completed for MSS and MSS_MO.

| Phase | Backend | Flutter integration | Status |
|---|---|---|---|
| 1. Foundation | Authenticated MSS context validation, profile/organisation scope, common responses, pagination, exceptions, R2/R3 clients, mobile repositories, action audit and idempotency | Shared API foundation, active-context headers and common API error handling | Integrated |
| 2. Context and navigation | `GET/PUT /ermobile/api/mss/v1/context`, `POST /organisations`, `GET /approval-filters` | ESS/MSS/MSS_MO profile selection, MO organisation selection and versioned SharedPreferences filter cache | Integrated |
| 3. Dashboard | `GET /ermobile/api/mss/v1/dashboard` | Count cards, descending quick actions, card navigation and profile/organisation/action refresh | Integrated |
| 4. Attendance | `/attendance-approvals` list, detail, attachment and actions | Pending/actioned tabs, search/type/stage/branch filters, pagination, sorting, detail/history, attachment and approve/reject/send-back/forward | Integrated |
| 5. Remaining approvals | `/requisitions?module=LEAVE|OD|WFH|COMP_OFF`, detail, history and decision | Shared approval screen with module-specific labels, filters, details, history and decisions | Integrated |
| 6. Employee and team | `/team/summary`, `/team/employees`, employee detail and attendance summary | Team metrics, employee filters/search/sort/pagination, profile-scoped detail and monthly attendance | Integrated |
| 7. Induction and exit | `/lifecycle/induction`, `/lifecycle/exit`, `/lifecycle/exit-employees`, detail/history/decision endpoints | Induction and exit dashboard actions, pending/actioned lists, exit employee cases, details/history and approve/reject | Integrated |

## Testing order

1. Login with ESS + MSS, verify ESS is selected and MSS profile switching is exclusive.
2. Login without ESS, verify the first allowed MSS profile is selected.
3. Select an MSS_MO profile and change organisation once; verify dashboard and filters use the selected child organisation.
4. Test dashboard card count against each pending list.
5. Complete one action in each approval module and verify list and dashboard counts refresh.
6. Verify an employee outside the active profile scope cannot be opened through a direct URL/API call.
7. Test induction and exit approve/reject with a repeated `Idempotency-Key` and verify only one action is recorded.
