module Db.TableColumns (
  employees
) where


employees :: { id :: String
, empId :: String
, uuid :: String
, billableRate :: String
}

employees = {
  id: "id",
  empId: "emp_id",
  uuid: "uuid",
  billableRate: "billable_rate"
}
