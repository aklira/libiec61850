/* File : iec61850.i */
%module iec61850
%ignore ControlObjectClient_setTestMode(ControlObjectClient self);
%ignore CDA_OperBoolean(ModelNode* parent, bool isTImeActivated);
%ignore LogicalNode_hasBufferedReports(LogicalNode* node);
%ignore LogicalNode_hasUnbufferedReports(LogicalNode* node);
%ignore MmsConnection_setIsoConnectionParameters(MmsConnection self, IsoConnectionParameters* params);
%include "stdint.i"

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

/*
%typemap(memberin) uint8_t [ANY] {
  int i;
  for (i = 0; i < $1_dim0; i++) {
      $1[i] = $input[i];
  }
}*/

%{
#include <iec61850_client.h>
#include <iec61850_model.h>
#include <iec61850_server.h>
ModelNode* toModelNode(LogicalNode * ln)
{ return (ModelNode*) ln;}
ModelNode* toModelNode(DataObject * DO)
{ return (ModelNode*) DO;}
char* toCharP(void * v)
{ return (char *) v;}
DataAttribute* toDataAttribute(DataObject * DO)
{ return (DataAttribute*)DO;}
DataAttribute* toDataAttribute(ModelNode * MN)
{ return (DataAttribute*)MN;}
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
%}
%apply int *OUTPUT {IedClientError* error};
%apply int *OUTPUT {MmsError* error};

%include "libiec61850_common_api.h"
%include "iec61850_client.h"
%include "iso_connection_parameters.h"
%include "mms_client_connection.h"
%include "iso_connection_parameters.h"
%include "iec61850_common.h"
%include "mms_value.h"
%include "iec61850_model.h"
%include "iec61850_server.h"
%include "iec61850_dynamic_model.h"
%include "iec61850_cdc.h"
%include "linked_list.h"
%include "mms_common.h"
ModelNode* toModelNode(LogicalNode *);
ModelNode* toModelNode(DataObject *);
DataAttribute* toDataAttribute(DataObject *);
DataAttribute* toDataAttribute(ModelNode *);
char* toCharP(void *);
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
