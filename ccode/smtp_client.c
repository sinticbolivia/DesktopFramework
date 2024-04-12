#include "smtp.h"

struct smtp *smtpData;

int smtp_client_open(
	const char *server, 
	const char *port, 
	enum smtp_connection_security connection_security, 
	enum smtp_flag flags, 
	const char *cafile
)
{
	printf("OPENING SMTP SERVER:: %s => %s\n", server, port);
	int res = smtp_open(server, port, connection_security, flags, cafile, &smtpData);
	printf("SMTP OPEN RES: %d\n", res);
	return res;
}
void smtp_client_close()
{
	if( smtpData == NULL )
		return;
	smtp_close(smtpData);
}
int smtp_client_auth(enum smtp_authentication_method auth_method, const char *username, const char *password)
{
	int res = smtp_auth(smtpData, auth_method, username, password);
	printf("SMTP AUTH RES: %d\n%s:%s\n", res, username, password);
	
	return res;
}
int smtp_client_add_address_from(const char* mail_from, const char* mail_from_name)
{
	int res = smtp_address_add(smtpData, SMTP_ADDRESS_FROM, mail_from, mail_from_name);
	printf("SMTP ADD ADDRESS FROM RES: %d\n", res);
	
	return res;
}
int smtp_client_address_add(const char* address, const char* address_name)
{
	int res = smtp_address_add(smtpData, SMTP_ADDRESS_TO, address, address_name);
	printf("SMTP ADD ADDRESS TO RES: %d\n", res);
	return res;
}
int smtp_client_add_header(const char* header, const char* value)
{
	return smtp_header_add(smtpData, header, value);
}
int smtp_client_mail(const char* subject, const char* body)
{
	int res = smtp_client_add_header("Subject", subject);
	printf("SMTP ADD SUBJECT RES: %d\n", res);
	
	res = smtp_mail(smtpData, body);
	printf("SMTP SEND MAIL RES: %d\n", res);
	return res;
}
int smtp_client_add_attach_file(const char* filename, const char* name)
{
	return smtp_attachment_add_path(smtpData, name, filename);
}
int smtp_client_add_attach_data(const char* name, const char* data, int length)
{
	return smtp_attachment_add_mem(smtpData, name, data, sizeof(char) * length);
}
