AccountView = React.createClass
  getInitialState: () ->
    return {
      address: @props.address
      balance: null
      blocks_mined: []
      transactions: []
      transactions_blocks: {}
      has_requested_transactions: true
      has_requested_blocks_mined: false
      back: @showAddressView
    }
  componentDidMount: () ->
    getBlock = (number) =>
      $.getJSON "#{Config.blockapps_host}/query/block?number=#{number}", (result, textStatus, jqXHR) =>
        block = result[0]
        transactions_blocks = @state.transactions_blocks
        transactions_blocks[number] = block
        @setState(transactions_blocks: transactions_blocks)

    $.getJSON "#{Config.blockapps_host}/query/account?address=#{@state.address}", (statuses, textStatus, jqXHR) =>
      @setState(balance: statuses[0].balance)

    $.getJSON "#{Config.blockapps_host}/query/transaction?address=#{@state.address}", (transactions, textStatus, jqXHR) =>
      @setState {
        transactions: transactions
        has_requested_transactions: true
      }

      for transaction in transactions
        getBlock(transaction.blockNumber)

    $.getJSON "#{Config.blockapps_host}/query/block?coinbase=#{@state.address}", (blocks_mined, textStatus, jqXHR) =>
      @setState {
        blocks_mined: blocks_mined
        has_requested_blocks_mined: true
      }

  refresh: () ->
    @props.refresh(@state.address)

  render: () ->
    activities = []

    # I get a warning if I don't manage the keys, so here goes. 
    key = -1

    for transaction in @state.transactions
      key += 1
      continue if !@state.transactions_blocks[transaction.blockNumber]?
      activities.push <Activity key={key} type={transaction.transactionType}  transaction={transaction} block={@state.transactions_blocks[transaction.blockNumber]} address={@state.address}/>

    for block in @state.blocks_mined
      key += 1
      activities.push <Activity key={key} type="Mined" block={block} address={@state.address}/>

    # Sort activities by timestamp
    activities = activities.sort (a,b) ->
      a = new Date(a.props.block.blockData.timestamp).getTime()
      b = new Date(b.props.block.blockData.timestamp).getTime()
      return b - a


    items = []
    balance = "..."
    denomination = "ETH"
    address = @state.address

    if @state.balance?
      balance_object = Utils.prettyAmountAsObject(@state.balance)
      balance = balance_object.value
      denomination = Utils.shortDenomination(balance_object.denomination)

    items.push 
      name: "Total Balance"
      value: balance
      string: denomination

    items.push
      name: "Transactions"
      value: if @state.has_requested_transactions then @state.transactions.length else "..."
      image: "transactions"

    items.push
      name: "Blocks Mined"
      value: if @state.has_requested_blocks_mined then @state.blocks_mined.length else "..." 
      image: "mined"

    <div id="account_view" className="view list">
      <Sidebar items={items} buttonName="Refresh Your Account" buttonAction={@refresh} />
      <div className="main container">
        <div className="top">
          <h4 className="four columns offset-by-one">Activity</h4>
          <h6 className="six columns address">
            <span className="pull-right">Address</span>
            <span className="pull-right">{address}</span>
          </h6>
        </div>
        {activities}
      </div>
    </div>

window.AccountView = AccountView