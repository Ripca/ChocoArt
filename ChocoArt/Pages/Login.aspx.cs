using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ChocoArt.Pages
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["logout"] == "1")
            {
                Session.Clear();
                Session.Abandon();
                // Optionally redirect to self without query string to clean URL
                Response.Redirect("Login.aspx");
            }

            if (Session["Usuario"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }
    }
}
