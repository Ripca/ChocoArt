using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ChocoArt.Controllers
{
    /// <summary>
    /// Summary description for ChocoArtHandler
    /// </summary>
    public class ChocoArtHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            context.Response.Write("Hello World");
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}