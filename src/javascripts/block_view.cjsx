BlockView = React.createClass
  getInitialState: () ->
    return {
      block: null
      has_requested_block: false
    }
  componentDidMount: () ->
    $.getJSON "#{Config.blockapps_host}/query/block/number/#{@props.number}", (result, textStatus, jqXHR) =>
      @setState {
        block: result[0]
        has_requested_block: true
      }

  searchAgain: () ->
    @props.back()

  render: () ->
    activities = []

    data = ""
    key = -1

    block = if @state.block? then @state.block.blockData else {}

    if @state.block?
      for transaction in @state.block.receiptTransactions
        key += 1
        activities.push <Activity key={key} type={transaction.transactionType}  transaction={transaction} block={@state.block}/>

      data = <pre className="ten columns offset-by-one" dangerouslySetInnerHTML={{__html: JSON.stringify(block, null, 2)}}></pre>

    items = []
    gasUsed = "..."
    denomination = "ETH"

    if @state.has_requested_block?
      gas_object = Utils.prettyAmountAsObject(block.gasUsed || 0)
      gasUsed = gas_object.value
      denomination = Utils.shortDenomination(gas_object.denomination)
    
    items.push 
      name: "Gas Used"
      value: gasUsed
      string: denomination

    items.push
      name: "Difficulty"
      value: block.difficulty || "..."

    items.push
      name: "Date Mined"
      value: if block? then moment(block.timestamp).format("DD/MM/YY h:mm:ss A") else "..."

    <div className="view list">
      <Sidebar items={items} searchButtonName="Search Again" searchButtonAction={@searchAgain} />
      <div className="main container">
        <h4 className="ten columns offset-by-one">Block<span dangerouslySetInnerHTML={{__html: '&nbsp;'}} /><span>#{@props.number}</span></h4>
        {if activities.length == 0 then <div className="ten columns offset-by-one">No transactions found for this block.</div> else activities}
        <h4 className="ten columns offset-by-one">Data</h4>
        {data}
      </div> 
    </div>



window.BlockView = BlockView