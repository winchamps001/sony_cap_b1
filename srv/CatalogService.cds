using { preetam.db } from '../db/datamodel';




service CatalogService @(path:'CatalogService',
    //authentication
    requires: 'authenticated-user') {
    //All the CURDQ - Create, Update, Read, Delete and Query operation on odata
    // @readonly
    entity EmployeeSrv 
    //authorization
    @(restrict: [
        {grant: ['READ'], to: 'Viewer', where: 'bankName = $user.BankName'},
        {grant: ['WRITE'], to: 'Admin'}
    ]) as projection on db.master.employees;
    //Other entities
    entity BusinessPartnerSet as projection on db.master.businesspartner;
    entity BPAddressSet as projection on db.master.address;
    entity ProductSet as projection on db.master.product;
    // entity PurchaseOrderSet as projection on db.transaction.purchaseorder{
    entity PurchaseOrderSet @(odata.draft.enabled:true,
                              Common.DefaultValuesFunction: 'getOrderDefault' ) 
    as projection on db.transaction.purchaseorder{
        *,
        case OVERALL_STATUS
            when 'P' then 'Pending'
            when 'A' then 'Approved'
            when 'X' then 'Rejected'
            when 'N' then 'New'
             end as OverallStatus: String(32),
        case OVERALL_STATUS
            when 'P' then 2
            when 'A' then 3
            when 'X' then 1
            when 'N' then 2
             end as IconColor: Integer
    }

    actions{
        //definition of our action which will get called by passing the NODE_KEY
        action boost() returns PurchaseOrderSet;
    };
    entity POItems as projection on db.transaction.poitems;


    //function getLargestOrder() returns array of PurchaseOrderSet;
    function getLargestOrder() returns PurchaseOrderSet;
}
