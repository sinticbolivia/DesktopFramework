//[CCode (cheader_filename = "../ccode/smtp.h")]
namespace SinticBolivia.Classes
{
	[CCode(cname = "smtp_connection_security", cprefix = "SMTP_", has_type_id = false)]
	[Flags]
	public enum SmtpFlags
	{
		DEBUG,
		NO_CERT_VERIFY
	}
	[CCode(cname = "smtp_flags", cprefix = "SMTP_", has_type_id = false)]
	public enum SmtpConnectionSecurity
	{
		SECURITY_STARTTLS,
		SECURITY_TLS,
		SECURITY_NONE
	}
	[CCode(cname = "smtp_address_type", cprefix = "SMTP_", has_type_id = false)]
	public enum SmtpAddressType
	{
		ADDRESS_FROM,
		ADDRESS_TO,
		ADDRESS_CC,
		ADDRESS_BCC
	}
	[CCode(cname = "smtp_status_code", cprefix = "SMTP_", has_type_id = false)]
	public enum SmtpStatusCode{
		STATUS_OK,
		STATUS_NOMEM,
		STATUS_CONNECT,
		STATUS_HANDSHAKE,
		STATUS_AUTH,
		STATUS_SEND,
		STATUS_RECV,
		STATUS_CLOSE,
		STATUS_SERVER_RESPONSE,
		STATUS_PARAM,
		STATUS_FILE,
		STATUS_DATE,
		STATUS__LAST
	}
	[CCode(cname = "smtp_authentication_method", cprefix = "SMTP_", has_type_id = false)]
	public enum SmtpAuthMethod
	{
		AUTH_CRAM_MD5,
		AUTH_NONE,
		AUTH_PLAIN,
		AUTH_LOGIN
	}
	[CCode (cname = "smtp_client_open")]
	public extern int smtp_open(
		string server,
		string port,
		SmtpConnectionSecurity connection_security,
		SmtpFlags flags,
		string? cafile
	);
	[CCode(cname = "smtp_client_close")]
	public extern int smtp_close();
	[CCode(cname = "smtp_client_auth")]
	public extern int smtp_auth(SmtpAuthMethod auth_method, string username, string password);
	[CCode(cname = "smtp_client_add_address_from")]
	public extern int smtp_add_from(string mailFrom, string mailFromName);
	[CCode(cname = "smtp_client_address_add")]
	public extern int smtp_address_add(string address, string address_name);
	[CCode(cname = "smtp_client_add_attach_file")]
	public extern int smtp_add_attachment_file(string filename, string name);
	[CCode(cname = "smtp_client_add_attach_data")]
	public extern int smtp_add_attachment_data(string name, uint8[] data);
	[CCode(cname = "smtp_client_mail")]
	public extern int smtp_mail(string subject, string body);

	//[CCode(cname = "smtp", destroy_function = "smtp_close", has_type_id = false)]
	public class SBSmtpClient
	{
		public		string 	server;
		public		int 	port = 25;

		public SBSmtpClient()
		{

		}

		public bool open(SmtpConnectionSecurity security = SmtpConnectionSecurity.SECURITY_NONE) throws SBException
		{
			if( this.server == null || this.server.strip().length <= 0 )
				throw new SBException.GENERAL("Nombre de servidor incorrecto, no se puede abrir SMTP");

			int res = smtp_open(
				this.server,
				this.port.to_string(),
				//SmtpConnectionSecurity.SECURITY_NONE | SmtpConnectionSecurity.SECURITY_TLS | SmtpConnectionSecurity.SECURITY_STARTTLS,
				//SmtpConnectionSecurity.SECURITY_TLS,
				//SmtpConnectionSecurity.SECURITY_STARTTLS,
				security,
				//SmtpFlags.DEBUG | SmtpFlags.NO_CERT_VERIFY,
				SmtpFlags.NO_CERT_VERIFY,
				null
			);
			if( res == SmtpStatusCode.STATUS_CONNECT )
				throw new SBException.GENERAL("No se puede conectar con el servidor SMTP");
			return true;
		}
		public void close()
		{
			smtp_close();
		}
		public void auth(string username, string password, SmtpAuthMethod auth_method = SmtpAuthMethod.AUTH_NONE) throws SBException
		{
			int res = smtp_auth(auth_method, username, password);
			if( res == SmtpStatusCode.STATUS_AUTH )
				throw new SBException.GENERAL("No se puede autenticar en el servidor SMTP");
		}
		public void addFrom(string mail, string name)
		{
			smtp_add_from(mail, name);
		}
		public void addAddress(string address, string address_name = "")
		{
			smtp_address_add(address, address_name);
		}
		public void addAttachmentFile(string filename)
		{
			smtp_add_attachment_file(filename, Path.get_basename(filename));
		}
		public void addAttachmentData(string name, uint8[] data)
		{
			smtp_add_attachment_data(name, data);
		}
		public void send(string subject, string body)
		{
			int res = smtp_mail(subject, body);
		}
	}
}
