namespace sony.metro;

//custom aspect
using { sony.metro.reuse as reuse } from './myreuse';

//sap also provide standard aspects like - ID generation - id, temportal, managed
//Ctrl+click to view sap provided aspects
using { cuid, managed, temporal } from '@sap/cds/common';


entity student {
    key id: String(32);
    name : String(255);
    gender: String(1);
    rollNo: Integer64;
    //foreign key = column name = class CONCATE id = class_id
    class: Association to one class;
}

entity book {
    key id: reuse.Guid;
    bookName : localized String(64);
    author: String(64);
}



entity class {
    key id: String(32);
    specialization: String(255);
    semester: Int32;
    hod: String(64);
        // student: Association to many student on student.class = $self;
}

//reusing aspects from sap standard to bring fields for id, createdBy, 
//changedBy, validFrom, validTo

entity Subs : cuid, managed, temporal {
    student: Association to one student;
    book: Association to  one book;
}
