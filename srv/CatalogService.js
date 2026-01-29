const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService { init() {

  const { EmployeeSrv, BusinessPartnerSet, BPAddressSet, ProductSet, PurchaseOrderSet, POItems } = cds.entities('CatalogService')

    this.before (['CREATE', 'UPDATE'], EmployeeSrv, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSrv', req.data)
    if(parseFloat(req.data.salaryAmount) >= 1000000){
      //induce an Error to tell CAP framework that we have an issue
      req.error(500, "Wallah!! Salary cannot be above 1 mn");
    }
  })


    //replace complete SAP standard code to fetch only 5 employees
  this.on ('READ', EmployeeSrv, async (employeeSrv, req) => {
    let results = await SELECT.from(EmployeeSrv).limit(5);
    console.log(results);
    for(var empRec of results){
      empRec.nameMiddle = '**on fly change**';
    }
    return results;
  })



  this.before (['CREATE', 'UPDATE'], EmployeeSrv, async (req) => {
    console.log('Before CREATE/UPDATE EmployeeSrv', req.data)
  })
  this.after ('READ', EmployeeSrv, async (employeeSrv, req) => {
    console.log('After READ EmployeeSrv', employeeSrv)
  })
  this.before (['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
    console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
  })
  this.after ('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
    console.log('After READ BusinessPartnerSet', businessPartnerSet)
  })
  this.before (['CREATE', 'UPDATE'], BPAddressSet, async (req) => {
    console.log('Before CREATE/UPDATE BPAddressSet', req.data)
  })
  this.after ('READ', BPAddressSet, async (bPAddressSet, req) => {
    console.log('After READ BPAddressSet', bPAddressSet)
  })
  this.before (['CREATE', 'UPDATE'], ProductSet, async (req) => {
    console.log('Before CREATE/UPDATE ProductSet', req.data)
  })
  this.after ('READ', ProductSet, async (productSet, req) => {
    console.log('After READ ProductSet', productSet)
  })
  this.before (['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
    console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
  })

  
  this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {


    // console.log(purchaseOrderSet)
    // //take all the PO id's in a array
    // const ids = purchaseOrderSet.map(purchaseorder => purchaseorder.NODE_KEY);
    // console.log(ids)


    //query all the items count (group by) where my POIDs = ids we collected
    //PARENT_KEY, count
    //ORD1, 2 ; ORD2 : 5; ORD3 :4
    // const itemsCount = await SELECT.from(PurchaseOrderSet)
    //                                .columns('NODE_KEY', {func : 'count'})
    //                                .where({NODE_KEY : {in : ids}})
    //                                .groupBy('PARTNER_GUID');
    // console.log(itemsCount)
   
    //Loop at the data which we need send out
    for(const poRecord of purchaseOrderSet){
      //reading the record of items from last computation for each po
      if(!poRecord.NOTE){
        poRecord.NOTE = "(no note found)"
      }
    }



    // for(const poRecord of purchaseOrderSet){
    //   //reading the record of items from last computation for each po
    //   const poCount = itemsCount.find(rec => rec.NODE_KEY = poRecord.NODE_KEY)
    //   //updating the items data
    //   poRecord.NO_OF_ITEMS = poCount.count;
    // }
    //find the count of corresponding order
    //add the virtual field value




  })



  // this.after ('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
  //   console.log('After READ PurchaseOrderSet', purchaseOrderSet)
  // })
  this.before (['CREATE', 'UPDATE'], POItems, async (req) => {
    console.log('Before CREATE/UPDATE POItems', req.data)
  })
  this.after ('READ', POItems, async (pOItems, req) => {
    console.log('After READ POItems', pOItems)
  })

  // this.on ('getLargestOrder', async (req) => {
  //   console.log('On getLargestOrder', req.data)
  // })

    this.on('getLargestOrder', async (req, res) => {
    try{
      //initiate an DB transaction
      const tx = cds.tx(req);
      //call DB table with CQL to fetch largest amount of PO
      const reply = await tx.read(PurchaseOrderSet).orderBy({
        "GROSS_AMOUNT" : 'desc'
      }).limit(1);


      return reply;
    }catch{


    }
  });

    this.on('getOrderDefault', async (req, res) => {
    try{
      return {
        OVERALL_STATUS : 'N'
      };
    }catch{


    }
  });


    //implementation of our action
  //if a user boost the PO, increase the GROSS amount by 20000 (update data in DB)
  this.on('boost', async (req, res) => {
    try{
      //Extract the ID (key) of the PO {NODE_KEY: '4df54sd4f5s454f65d4s'}
      const NODE_KEY = req.params[0];
      console.log("Bro!! I got an ID ===> " + NODE_KEY);
      //initiate an DB transaction
      const tx = cds.tx(req);
      //call DB table with CQL to fetch largest amount of PO
      await tx.update(PurchaseOrderSet).with({
        GROSS_AMOUNT: {'+=' : 20000},
        NOTE: 'boosted!'
      }).where(NODE_KEY);


      const reply = await tx.read(PurchaseOrderSet).where(NODE_KEY);


      return reply;
    }catch{


    }
  });


  //implementation for function
  this.on('getLargestOrder', async (req, res) => {
    try{
      //initiate an DB transaction
      const tx = cds.tx(req);
      //call DB table with CQL to fetch largest amount of PO
      const reply = await tx.read(PurchaseOrderSet).orderBy({
        "GROSS_AMOUNT" : 'desc'
      }).limit(1);


      return reply;
    }catch{


    }
  });



  return super.init()
}}
