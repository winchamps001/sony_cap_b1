const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {



  this.on ('hello', async (req) => {
    return "Hey Amigo ! " + req.data.name + " welcome to capm service";
  })


  return super.init()
}}
