sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"sony/preetam/managepurchaseorder/test/integration/pages/PurchaseOrderSetList",
	"sony/preetam/managepurchaseorder/test/integration/pages/PurchaseOrderSetObjectPage",
	"sony/preetam/managepurchaseorder/test/integration/pages/POItemsObjectPage"
], function (JourneyRunner, PurchaseOrderSetList, PurchaseOrderSetObjectPage, POItemsObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('sony/preetam/managepurchaseorder') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetList: PurchaseOrderSetList,
			onThePurchaseOrderSetObjectPage: PurchaseOrderSetObjectPage,
			onThePOItemsObjectPage: POItemsObjectPage
        },
        async: true
    });

    return runner;
});

