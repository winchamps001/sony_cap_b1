namespace sony.metro.reuse;

type Guid : String(32)  @title : 'Key';

//aspects - like a structure which is the combination of fields
aspect address{
    city: String(32);
    country: String(64);
    region: String(2);
    landmark: String(255);
    houseNo: Int16;
}
