using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;


using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;


namespace webapi.Controllers
{

    [Authorize]
    public class SocketHub : Hub
    {
        private readonly static ConnectionMapping<string> _connections =
         new ConnectionMapping<string>();

        private ILogger _logger;
        public SocketHub(ILogger<SocketHub> logger)
        {
            this._logger = logger;
        }

        public override Task OnConnectedAsync()
        {
            var username = getUsername();

            foreach (var connectionId in _connections.GetConnections(username))
            {
                Clients.Client(connectionId).SendAsync("metodo-en-telefono-logout");
                _logger.LogInformation($"Cerrando sesión {connectionId}");
            }

            _connections.Add(username, Context.ConnectionId);

            _logger.LogInformation($"Connect: {username} > {this.Context.ConnectionId} ");


            return base.OnConnectedAsync();
        }

        public override Task OnDisconnectedAsync(Exception exception)
        {

            try
            {
                var username = getUsername();

                _connections.Remove(username, Context.ConnectionId);

                _logger.LogInformation($"Disconnect: {username} > {this.Context.ConnectionId} ");
            }
            catch (Exception ex)
            {

                _logger.LogError(ex.Message);
            }


            if (exception != null)
            {
                _logger.LogInformation(exception.Message);
            }

            return base.OnDisconnectedAsync(exception);
        }

        // public async Task Logout()
        // {
        //     var username = getUsername();
        //     foreach (var connectionId in _connections.GetConnections(username))
        //     {
        //         await Clients.Client(connectionId).SendAsync("logout");
        //     }

        //     _logger.LogInformation($"Logout: {username} > {this.Context.ConnectionId} ");
        //     return;
        // }

        private string getUsername()
        {
            return this.Context
                            .User
                            .Claims
                            .FirstOrDefault(c =>
                                    string.Compare(c.Type, ClaimTypes.Name, false, CultureInfo.CurrentCulture) == 0)?
                                    .Value
                                    .ToLower();

        }
    }
}
