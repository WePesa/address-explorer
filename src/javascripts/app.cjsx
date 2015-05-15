App = React.createClass
  getInitialState: () ->
    if window.location.search != ""
      address = window.location.search.substring(1)
      return {view: <AccountView key={new Date().getTime()} address={address} refresh={@refresh}/>}

    return {view: <AddressView onSubmit={@refresh}/>}
  refresh: (address) ->
    @setState
      address: address
      view: <AccountView key={new Date().getTime()} address={address} refresh={@refresh}/>
  getAddress: () ->
    return @state.address
  render: () ->
    <div className="app">
      {@state.view}
    </div>
      
$(document).on "ready", () ->
  React.render(<App/>, document.body)     