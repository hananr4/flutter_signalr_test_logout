namespace webapi.Model
{

    public class LoginResponse
    {
        public bool Ok { get; set; }
        public string Token { get; set; }
        public string Mensaje { get; set; }
        public string Username { get;  set; }
        public string Name { get; set; }
    }
}