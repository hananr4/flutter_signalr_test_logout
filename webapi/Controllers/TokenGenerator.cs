using Microsoft.IdentityModel.Tokens;
using System;
using System.Text;
using System.Security.Claims;
using System.IdentityModel.Tokens.Jwt;

namespace webapi.Controllers
{
    internal static class TokenGenerator
    {
        public static string GenerateTokenJwt(string username)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.Default.GetBytes("this is my custom Secret key for authnetication"));
            var signingCredentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256Signature);


            // create a claimsIdentity
            ClaimsIdentity claimsIdentity = new ClaimsIdentity(new[] {
                new Claim(ClaimTypes.Name, username),
            });

            // create token to the user
            var tokenHandler = new System.IdentityModel.Tokens.Jwt.JwtSecurityTokenHandler();
            var jwtSecurityToken = tokenHandler.CreateJwtSecurityToken(
                audience: "AudienceToken",
                issuer: "IssuerToken",
                subject: claimsIdentity,
                notBefore: DateTime.UtcNow,
                expires: DateTime.UtcNow.AddMinutes(60),
                signingCredentials: signingCredentials
                );

            var jwtTokenString = tokenHandler.WriteToken(jwtSecurityToken);
            return jwtTokenString;



        }

    }
}
