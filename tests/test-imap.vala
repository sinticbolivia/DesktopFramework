using SinticBolivia;
using SinticBolivia.Classes;

public int main(string[] args)
{
    string username = "soporte@sinticbolivia.net";
    string pass = "YfxboWtwp5yQ";
    string server = "mail.sinticbolivia.net";

    var checker = new EmailChecker(server, username, pass, 993);
    //checker.check_email_imap("FETCH 1:5 (BODY[HEADER.FIELDS (SUBJECT FROM)] BODY[TEXT])");
    checker.check_email_imap("FETCH 1:5 (BODY[HEADER.FIELDS (SUBJECT)] BODY[TEXT])");
    return 0;
}
