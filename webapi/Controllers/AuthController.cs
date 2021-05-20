using System.Globalization;
using System.Linq;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using webapi.Model;

namespace webapi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AuthController : ControllerBase
    {
        ILogger _logger;
        public AuthController(ILogger<AuthController> logger ){
            _logger = logger;
        }

        [HttpPost("Login")]
        [AllowAnonymous]
        public IActionResult Login(LoginRequest request)
        {
            _logger.LogInformation("Login");

            LoginResponse response = new LoginResponse() { Ok = true };

            if (response.Ok)
            {
                response.Token = TokenGenerator.GenerateTokenJwt(request.Username);
                response.Name = request.Username;
                return Ok(response);
            }
            else
            {
                return Unauthorized(response);
            }
        }

        
        [HttpPost("renew")]
        [Authorize]
        public IActionResult Renew()
        {
            LoginResponse response = new LoginResponse() { Ok = true };
            string username = this.User.Claims.FirstOrDefault(c => string.Compare(c.Type, ClaimTypes.Name, false, CultureInfo.CurrentCulture) == 0)?.Value;


            if (response.Ok)
            {
                response.Token = TokenGenerator.GenerateTokenJwt(username);
                response.Name = username;
                return Ok(response);
            }
            else
            {
                return Unauthorized(response);
            }
        }

    }
}