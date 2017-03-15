
let Temperature = {

  init(socket, element) {
    let channel = socket.channel("temp:1", {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })


    socket.connect();
    channel.on("temp", (resp) => {
      element.innerHTML = resp.temp;

    });
  }
}

export default Temperature
