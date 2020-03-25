// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("inn_check", {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


const error_tpl = (error) => {
  document.querySelector("#error").innerHTML = error;
}; 

const success_tpl = (message) => {
  let table = document.querySelector("#data_table");
  let row = table.insertRow(0);
  let cell_date_time = row.insertCell(0);
  let cell_number = row.insertCell(1);
  let cell_is_valid = row.insertCell(2);
  cell_date_time.innerHTML = message.inserted_at;
  cell_number.innerHTML = message.number;
  cell_is_valid.innerHTML = message.is_valid ? "корректен": "некорректен";
}; 

document.querySelector('#inn_number').focus();

document.querySelector('#send_inn').addEventListener('submit', (e) => {
  e.preventDefault();
  let input_value = e.target.querySelector('#inn_number');

  channel.push('inn_add', { number: input_value.value }).receive(
    "ok", (reply) => success_tpl(reply.message)
  ).receive(
    "error", (reply) => error_tpl(reply.message)
  );
  input_value.value = '';
  input_value.focus();
  error_tpl('')
});



export default socket
