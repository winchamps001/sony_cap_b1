using CatalogService as service from '../../srv/CatalogService';

//Annotate our entity on which we created fiori app
annotate service.PurchaseOrderSet with @(
    // selection fields - to show filter fields
    UI.SelectionFields:[
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS
    ],

    // line item - to add columns to the table
    // Ctrl+space
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },

        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'CatalogService.boost',
            Label: 'boost',
            Inline: true
        },


        {
            $Type : 'UI.DataField',
            // Value : OVERALL_STATUS,
            Value : OverallStatus,
            Criticality: IconColor
        },

    ],

    //Header info to add the title of the table along with the
    //second page top arera
    UI.HeaderInfo:{
        TypeName: 'Purchase order',
        TypeNamePlural: 'Purchase orders',
        Title: { Value: PO_ID },
        Description: { Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSljd53JuHAuh-sQBQuqDLQU3Z0uXqxQ3sMHA&s',
    },

    //Add a tabstrip which has multiple tabs - Facets
    UI.Facets: [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'PO details',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'More Info',
                    Target : '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Pricing Data',
                    Target : '@UI.FieldGroup#Spiderman',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target : '@UI.FieldGroup#Superman',
                },
            ],
        },

        {
            $Type : 'UI.ReferenceFacet',
            Label : 'PO Items',
            Target : 'Items/@UI.LineItem',
        },


    ],

    //first block inside the collection facet - identification (default)
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },

       {
            $Type : 'UI.DataField',
            Value : NOTE,
       },


        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        }
    ],

    //other fields grouped in a field group for creating multiple blocks
    UI.FieldGroup #Spiderman: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },
            {
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
        ],
    },
    UI.FieldGroup #Superman: {
        Data : [
            {
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Value : LIFECYCLE_STATUS,
            },
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
        ],
    }


);

//annotate the purchase order item to create table for item and 3rd level drill down
annotate service.POItems with @(


    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ],

        UI.HeaderInfo:{
        TypeName : 'PO Item',
        TypeNamePlural: 'PO Items',
        Title : {Value : PO_ITEM_POS},
        Description: {Value : PRODUCT_GUID.DESCRIPTION}
    },
    UI.Facets: [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Item Details',
            Target : '@UI.Identification',
        },
    ],
    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },
        {
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        },
    ]


);

//Setting default value for a field on list report
annotate service.PurchaseOrderSet with {
    @Common : { FilterDefaultValue: 'P' }
    OVERALL_STATUS;
    @Common : { Text: PARTNER_GUID.COMPANY_NAME ,
                ValueList.entity : service.BusinessPartnerSet }
    PARTNER_GUID;
    @Common : { Text: NOTE }
    // NODE_KEY;
    ID;
    @Common: { Text: OverallStatus }
    OVERALL_STATUS;    
};

//Setting default value for a field on list report
annotate service.POItems with {
    @Common : { Text: PRODUCT_GUID.DESCRIPTION, 
                ValueList.entity : service.BusinessPartnerSet }
    PRODUCT_GUID;
}



//Annotate master data entities to support value help
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : COMPANY_NAME,
        },
    ]
);


@cds.odata.valuelist
annotate service.ProductSet with @(
    UI.Identification:[
        {
            $Type : 'UI.DataField',
            Value : DESCRIPTION,
        },
    ]
);


// //Setting default value for a field on list report
// annotate service.PurchaseOrderSet with {
//     @Common : { FilterDefaultValue: 'Talpa' }
//     COMPANY_NAME
// }
