///|
/// Calls the RPC service and prints the round-trip result.
async test "call service" {
  let client = @client_async.ServiceClient::new("http://localhost:8787/myapi")

  let tarzan = @skirout_user_skir.tarzan_const
  let add_req = @skirout_service_skir.AddUserRequest::new(user=tarzan)
  match
    client.invoke_remote(@skirout_service_skir.add_user_method, add_req, []) {
    Ok(_) => println("Added user Tarzan")
    Err(_) => panic()
  }

  let get_req = @skirout_service_skir.GetUserRequest::new(user_id=123)
  let response = match
    client.invoke_remote(@skirout_service_skir.get_user_method, get_req, []) {
    Ok(value) => value
    Err(_) => panic()
  }

  match response.user {
    Some(user) => {
      let json = @skirout_user_skir.User::serializer().to_readable_json(user)
      println("Got user: " + json.stringify())
    }
    None => println("User not found")
  }
}
