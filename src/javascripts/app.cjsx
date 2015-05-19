App = React.createClass
  getInitialState: () ->
    address = null
    if window.location.search != ""
      address = window.location.search.substring(1)
    return {view: @getViewFromInput(address)}
  refresh: (address) ->
    @setState
      address: address
      view: @getViewFromInput(address)
  getAddress: () ->
    return @state.address
  getViewFromInput: (input="") ->
    allNumbers = /^\d+$/

    # Check to see if it's a block number. Add a length check of 20 just to keep
    # things sane.
    if input.length > 20
      return <AccountView key={new Date().getTime()} address={input} refresh={@refresh}/>
    if input == ""
      return <AddressView onSubmit={@refresh}/>
    else if input.match(allNumbers)?
      return <BlockView number={input}/>
    else
      # Error case. We should do something better here.
      return <AddressView onSubmit={@refresh}/>

  render: () ->
    <div className="app">
      {@state.view}
    </div>
      
$(document).on "ready", () ->
  React.render(<App/>, document.body)     