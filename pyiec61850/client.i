// File : client.i

%typemap(in) uint8_t value[ANY] {
  int i;
  if (!PyList_Check($input)) {
    PyErr_SetString(PyExc_ValueError, "Expecting a list");
    SWIG_fail;
  }
  int l_length = PyList_Size($input);
  uint8_t temp[l_length];
  for (i = 0; i < l_length; i++) {
    PyObject *o = PyList_GetItem($input, i);
    if (PyNumber_Check(o)) {
      temp[i] = (uint8_t) PyInt_AsLong(o);
    } else {
      PyErr_SetString(PyExc_ValueError, "Sequence elements must be numbers");      
      SWIG_fail;
    }
  }
  $1 = temp;
}

%{
#include "mms_client_connection.h"
#include "mms_value_internal.h"

//Report Handlings
#define REPORT_BUFFERED		    0x01	//RBE flag, buffer reports
#define REPORT_INTERVAL_TIMEOUT 0x02    // send "General interrogations"
#define REPORT_OBJECT_CHANGES	0x04    // send reports

/*********************************************************************************************************/
static void
informationReportHandler(void* parameter, char* domainName,
        char* variableListName, MmsValue* value, bool isVariableListName)
{
    if (value) {
            printf("ICCP_CLIENT: received information report for %s\n", variableListName);
			MmsType type = MmsValue_getType(value);
			printf("type: %i\n", type);
			if (type == MMS_STRUCTURE){
				
				MmsValue * element1 = MmsValue_getElement(value, 0);
				MmsType typeElt1 = MmsValue_getType(element1);
			    printf("type element1: %i\n", typeElt1);

				if (typeElt1 == MMS_INTEGER || typeElt1 == MMS_UNSIGNED) {
					int32_t valuetoInt32 = MmsValue_toInt32(element1);
					printf("value = %i\n", valuetoInt32);
				}
		        else if (typeElt1 == MMS_FLOAT) {
					double valuetoDouble = MmsValue_toDouble(element1);
					printf("value = %f\n", valuetoDouble);
			    }
			}
    } else {
            printf("ICCP_CLIENT: report for %s/%s: value invalid\n", domainName, variableListName);
    }
}

/*********************************************************************************************************/
void write_dataset(MmsConnection con, char * id_iccp, char * ds_name, char * ts_name, int buffer_time, int integrity_time, int all_changes_reported)
{
	//global
	MmsError mmsError;
	MmsVariableSpecification * typeSpec= (MmsVariableSpecification*) calloc(1,sizeof(MmsVariableSpecification));
	typeSpec->type = MMS_STRUCTURE;
	typeSpec->typeSpec.structure.elementCount = 13;
	typeSpec->typeSpec.structure.elements = (MmsVariableSpecification**) calloc(13, sizeof(MmsVariableSpecification*));

	MmsVariableSpecification* element;

	//0
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->type = MMS_STRUCTURE;
	element->typeSpec.structure.elementCount = 3;
	element->typeSpec.structure.elements = (MmsVariableSpecification**) calloc(3, sizeof(MmsVariableSpecification*));

	MmsVariableSpecification* inside_element;
	//0.0
	inside_element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	inside_element->type = MMS_UNSIGNED;
	inside_element->typeSpec.unsignedInteger = 8;
	inside_element->typeSpec.structure.elementCount = 3;
	element->typeSpec.structure.elements[0] = inside_element;

	//0.1
	inside_element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	inside_element->type = MMS_VISIBLE_STRING;
	inside_element->typeSpec.visibleString = -129;
	element->typeSpec.structure.elements[1] = inside_element;

	//0.2
	inside_element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	inside_element->type = MMS_VISIBLE_STRING;
	inside_element->typeSpec.visibleString = -129;
	element->typeSpec.structure.elements[2] = inside_element;

	typeSpec->typeSpec.structure.elements[0] = element;

	//1
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.integer = 8;
	element->type = MMS_INTEGER;
	typeSpec->typeSpec.structure.elements[1] = element;

	//2
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.integer = 8;
	element->type = MMS_INTEGER;
	typeSpec->typeSpec.structure.elements[2] = element;

	//3
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.integer = 8;
	element->type = MMS_INTEGER;
	typeSpec->typeSpec.structure.elements[3] = element;

	//4
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.integer = 8;
	element->type = MMS_INTEGER;
	typeSpec->typeSpec.structure.elements[4] = element;

	//5
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.integer = 8;
	element->type = MMS_INTEGER;
	typeSpec->typeSpec.structure.elements[5] = element;

	//6
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.bitString = 5;
	element->type = MMS_BIT_STRING;
	typeSpec->typeSpec.structure.elements[6] = element;

	//7
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->type = MMS_BOOLEAN;
	typeSpec->typeSpec.structure.elements[7] = element;

	//8
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->type = MMS_BOOLEAN;
	typeSpec->typeSpec.structure.elements[8] = element;

	//9
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->type = MMS_BOOLEAN;
	typeSpec->typeSpec.structure.elements[9] = element;

	//10
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->type = MMS_BOOLEAN;
	typeSpec->typeSpec.structure.elements[10] = element;

	//11
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->type = MMS_BOOLEAN;
	typeSpec->typeSpec.structure.elements[11] = element;

	//12
	element = (MmsVariableSpecification*) calloc(1, sizeof(MmsVariableSpecification));
	element->typeSpec.integer = 8;
	element->type = MMS_INTEGER;
	typeSpec->typeSpec.structure.elements[12] = element;

	MmsValue* dataset = MmsValue_newStructure(typeSpec);

	//0
	MmsValue* elem;
	elem = MmsValue_getElement(dataset, 0);

	//0.0
	MmsValue* ielem;
	ielem = MmsValue_getElement(elem, 0);
	MmsValue_setUint8(ielem, 1);

	//0.1
	ielem = MmsValue_getElement(elem, 1);
	MmsValue_setVisibleString(ielem, id_iccp);

	//0.2
	ielem = MmsValue_getElement(elem, 2);
	MmsValue_setVisibleString(ielem, ds_name);

	//1
	elem = MmsValue_getElement(dataset, 1);
	MmsValue_setInt32(elem, 0);

	//2
	elem = MmsValue_getElement(dataset, 2);
	MmsValue_setInt32(elem, 0);

	//3
	elem = MmsValue_getElement(dataset, 3);
	MmsValue_setInt32(elem, 0);

	//4
	//Buffer interval
	elem = MmsValue_getElement(dataset, 4);
	MmsValue_setInt32(elem, buffer_time);

	//5
	//Integrity check time
	elem = MmsValue_getElement(dataset, 5);
	MmsValue_setInt32(elem, integrity_time);

	// 6
	elem = MmsValue_getElement(dataset, 6);

	if(all_changes_reported&REPORT_INTERVAL_TIMEOUT) //FIXME: events are sent only spontaneusly not in GI
		MmsValue_setBitStringBit(elem, 1, true);
	
	if(all_changes_reported&REPORT_OBJECT_CHANGES) 
		MmsValue_setBitStringBit(elem, 2, true);

	//7
	elem = MmsValue_getElement(dataset, 7);
	MmsValue_setBoolean(elem, true);

	//8
	elem = MmsValue_getElement(dataset, 8);
	MmsValue_setBoolean(elem, true);

	//9
	elem = MmsValue_getElement(dataset, 9);
	MmsValue_setBoolean(elem, true);

	//10
	//RBE?
	//FIXME: if true send notification if lost event
	elem = MmsValue_getElement(dataset, 10);
	if(all_changes_reported&REPORT_BUFFERED)
		MmsValue_setBoolean(elem, false);
	else
		MmsValue_setBoolean(elem, true);
	//MmsValue_setBoolean(elem, true);

	//11
	elem = MmsValue_getElement(dataset, 11);
	MmsValue_setBoolean(elem, true);

	//12
	elem = MmsValue_getElement(dataset, 12);
	MmsValue_setInt32(elem, 0);

	MmsConnection_writeVariable(con, &mmsError, id_iccp, ts_name, dataset );

	MmsVariableSpecification_destroy(typeSpec);
	MmsValue_delete(dataset);
}

/*********************************************************************************************************/
MmsError* toMmsErrorP()
{ MmsError e = MMS_ERROR_NONE; return &e;}
void setMmsVASArrayIndex(MmsVariableAccessSpecification * var, int val)
{ var->arrayIndex = val;}
char* getMmsVASItemId(MmsVariableAccessSpecification * var)
{ return var->itemId;}
MmsVariableSpecification* MmsVariableSpecification_create(int size)
{MmsVariableSpecification* var = (MmsVariableSpecification*) calloc(size,sizeof(MmsVariableSpecification)); return var;}
void setMmsVSType(MmsVariableSpecification* var, int val)
{ var->type = (MmsType) val;}
int getMmsVSType(MmsVariableSpecification* var)
{ return (int) var->type;}
void setMmsVSTypeSpecElementCount(MmsVariableSpecification* var, int val)
{ var->typeSpec.structure.elementCount = val;}
void MmsVSTypeSpecElements_create(MmsVariableSpecification* var, int size)
{ var->typeSpec.structure.elements = (MmsVariableSpecification**) calloc(size,sizeof(MmsVariableSpecification*));}
void setMmsVSTypeSpecUInt(MmsVariableSpecification* var, int val)
{ var->typeSpec.unsignedInteger = val;}
void setMmsVSTypeSpecElement(MmsVariableSpecification* var, MmsVariableSpecification* element, int i)
{ var->typeSpec.structure.elements[i] = element;}
void setMmsVSTypeSpecVString(MmsVariableSpecification* var, int val)
{ var->typeSpec.visibleString = val;}
void setMmsVSTypeInteger(MmsVariableSpecification* var, int val)
{ var->typeSpec.integer = val;}
void setMmsVSTypebitString(MmsVariableSpecification* var, int val)
{ var->typeSpec.bitString = val;}
MmsInformationReportHandler informationReportHandler_create()
{ return (MmsInformationReportHandler) informationReportHandler;}
%}
%apply int *OUTPUT {MmsError* error};

MmsError* toMmsErrorP();
void setMmsVASArrayIndex(MmsVariableAccessSpecification *, int);
char* getMmsVASItemId(MmsVariableAccessSpecification *);
MmsVariableSpecification* MmsVariableSpecification_create(int);
void setMmsVSType(MmsVariableSpecification *, int);
int getMmsVSType(MmsVariableSpecification*);
void setMmsVSTypeSpecElementCount(MmsVariableSpecification*, int);
void MmsVSTypeSpecElements_create(MmsVariableSpecification*, int);
void setMmsVSTypeSpecUInt(MmsVariableSpecification*, int);
void setMmsVSTypeSpecElement(MmsVariableSpecification*, MmsVariableSpecification*, int);
void setMmsVSTypeSpecVString(MmsVariableSpecification*, int);
void setMmsVSTypeInteger(MmsVariableSpecification*, int);
void setMmsVSTypebitString(MmsVariableSpecification*, int);
MmsInformationReportHandler informationReportHandler_create();
void write_dataset(MmsConnection, char *, char *, char *, int, int, int);