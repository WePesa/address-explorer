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
  showAddressView: () ->
    @setState(view: <AddressView onSubmit={@refresh}/>)
  getAddress: () ->
    return @state.address
  getViewFromInput: (input="") ->
    allNumbers = /^\d+$/

    # Check to see if it's a block number. Add a length check of 20 just to keep
    # things sane.
    if input.length > 20
      return <AccountView key={new Date().getTime()} address={input} refresh={@refresh} back={@showAddressView} />
    if input == ""
      return <AddressView onSubmit={@refresh} />
    else if input.match(allNumbers)?
      return <BlockView number={input} back={@showAddressView} />
    else
      # Error case. We should do something better here.
      return <AddressView onSubmit={@refresh} />

  render: () ->
    <div className="app">
      {@state.view}
    </div>
      
$(document).on "ready", () ->
  window.Config = {
    blockapps_host: "http://stablenet.blockapps.net" 
  }
  React.render(<App/>, document.body)  

# Prevent livestamp from using "a few seconds ago", primarily because
# it's a long string that doesn't fit in our layout.
$(document).on 'change.livestamp', (event, from, to) ->
  event.preventDefault() 
  if to == "a few seconds ago"
    to = "now"
  $(event.target).html(to)  