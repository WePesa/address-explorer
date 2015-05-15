AccountView = React.createClass
  getInitialState: () ->
    return {
      address: @props.address
      balance: null
      blocks_mined: []
      transactions: []
      transactions_blocks: {}
    }
  componentDidMount: () ->
    getBlock = (blockId) =>
      $.getJSON "http://api.blockapps.net/query/block/blockid/#{blockId}", (result, textStatus, jqXHR) =>
        block = result[0]
        # I'm not supposed to mutate @state directly. But this is pretty much the same thing...
        transactions_blocks = @state.transactions_blocks
        transactions_blocks[blockId] = block
        @setState(transactions_blocks: transactions_blocks)

    $.getJSON "http://api.blockapps.net/query/account/address/#{@state.address}", (statuses, textStatus, jqXHR) =>
      @setState(balance: statuses[0].balance)

    $.getJSON "http://api.blockapps.net/query/transaction/address/#{@state.address}", (transactions, textStatus, jqXHR) =>
      @setState(transactions: transactions)

      for transaction in transactions
        getBlock(transaction.blockId)

    $.getJSON "http://api.blockapps.net/query/block/coinbase/#{@state.address}", (blocks_mined, textStatus, jqXHR) =>
      @setState(blocks_mined: blocks_mined)

  refresh: () ->
    @props.refresh(@state.address)

  render: () ->
    activities = []

    # I get a waring if I don't manage the keys, so here goes. 
    key = -1

    for transaction in @state.transactions
      key += 1
      continue if !@state.transactions_blocks[transaction.blockId]?
      activities.push <Activity key={key} type={transaction.transactionType}  transaction={transaction} block={@state.transactions_blocks[transaction.blockId]} address={@state.address}/>

    for block in @state.blocks_mined
      key += 1
      activities.push <Activity key={key} type="Mined" block={block.blockData} address={@state.address}/>

    # Sort activities by timestamp
    activities = activities.sort (a,b) ->
      a = new Date(a.props.block.timestamp).getTime()
      b = new Date(b.props.block.timestamp).getTime()
      return b - a

    <div id="account_view" className="view">
      <div className="container">
        <h1 className="ten columns">
          Your Account{'\u00A0'}<span id="address_entered">({@props.address.substring(0, 15)})</span>
        </h1>
        <div className="two columns">
          <button id="refresh" onClick={@refresh}>
            Refresh
          </button>
        </div>

        <div className="five columns">
          <span className="icon">{'\u2130'}</span>{if @state.balance? then Utils.prettyAmount(@state.balance) else "..."}
          <br/><span className="label">Total Balance</span>
        </div>
        <div className="four columns">
          <span className="icon">{'\u21F5'}</span>{@state.transactions.length || "..."}
          <br/><span className="label">Transactions</span>
        </div>
        <div className="two columns">
          <span className="icon">{'\u229E'}</span>{@state.blocks_mined.length || "..."}
          <br/><span className="label">Blocks Mined</span>
        </div>

        <h4 className="twelve columns">Activity</h4>

        {activities}
      </div>
    </div>

window.AccountView = AccountView