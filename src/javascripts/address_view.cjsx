AddressView = React.createClass
  getInitialState: () ->
    return {address: ""}
  handleChange: (e) ->
    @setState({address: e.target.value})
  handleClick: () ->
    @props.onSubmit(@state.address)
  render: () ->
    <div id="address_view" className="view visible center">
      <div className="box">
        <div className="logo"></div>
        <div className="form">
          <label>Enter Ethereum Address or Block Number</label>
          <input ref="address" type="text" value={@state.address} onChange={@handleChange}></input>
          <button id="view_account" className="turquoise" onClick={@handleClick}>View Account</button>
        </div>
      </div>
    </div>

window.AddressView = AddressView