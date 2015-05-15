AddressView = React.createClass
  getInitialState: () ->
    return {address: "6a56cf7a57405800b18e3e0940628c190cfa73bc"}
  handleChange: (e) ->
    @setState({address: e.target.value})
  handleClick: () ->
    @props.onSubmit(@state.address)
  render: () ->
    <div id="address_view" className="view visible center">
      <div>
        <label>Enter Ethereum Address</label>
        <input ref="address" type="text" value={@state.address} onChange={@handleChange}></input>
        <button id="view_account" onClick={@handleClick}>View Account</button>
      </div>
    </div>

window.AddressView = AddressView