// File : client.i
%{
#include "mms_client_connection.h"
#include "mms_value_internal.h"

static void
informationReportHandler(void* parameter, char* domainName, char* variableListName, MmsValue* value, LinkedList attributes, int attributesCount)
{
	int i = 0;
	time_t time_stamp;
	const char * domain_id = NULL;
	const char * transfer_set = NULL;
	MmsError mmsError;
	unsigned short time_stamp_extended = 0;
	char * ts_extended;
	
	ts_extended = (char *)&time_stamp_extended;
	time(&time_stamp);
	if (value != NULL && attributes != NULL && attributesCount == 4 && parameter != NULL) {
        MmsConnection * con = (MmsConnection *)parameter;
		LinkedList list_names = LinkedList_getNext(attributes);
		while (list_names != NULL) {
			char * attribute_name = (char *) list_names->data;
			if(attribute_name == NULL){
				i++;
				printf( "ERROR - received report with null atribute name\n");
				continue;
			}
			list_names = LinkedList_getNext(list_names);
			MmsValue * dataSetValue = MmsValue_getElement(value, i);
			if(dataSetValue == NULL){
				i++;
				printf( "ERROR - received report with null dataset\n");
				continue;
			}

			if (strncmp("Transfer_Set_Name", attribute_name, 17) == 0) {
				MmsValue* ts_name;
				MmsValue* d_id;
				if(dataSetValue !=NULL) {
					d_id = MmsValue_getElement(dataSetValue, 1);
					if(d_id !=NULL) {
						domain_id = MmsValue_toString(d_id);
					} else {
						printf( "ERROR - Empty domain id on report\n");
					}
					ts_name = MmsValue_getElement(dataSetValue, 2);
					if(ts_name !=NULL) {
						transfer_set = MmsValue_toString(ts_name);
					} else {
						printf( "ERROR - Empty transfer set name on report\n");
					}
				} else {
					printf("ERROR - Empty data for transfer set report\n");
				}					
				i++;
				continue;
			}

			if (strncmp("Transfer_Set_Time_Stamp", attribute_name, 23) == 0) {
				time_stamp =  MmsValue_toUint32(dataSetValue);
				i++;
				continue;
			}

			i++;
		}
		MmsValue_delete(value);
	} else{
		printf( "ERROR - wrong report %d %d %d %d\n",value != NULL, attributes != NULL , attributesCount , parameter != NULL);
	}
}

MmsInformationReportHandler informationReportHandler_create()
{
    return (MmsInformationReportHandler) informationReportHandler;
}

%}

static void informationReportHandler(void*, char*, char*, MmsValue*, LinkedList, int);
MmsInformationReportHandler informationReportHandler_create();
