BlockView = React.createClass
  getInitialState: () ->
    return {
      block: null
    }
  componentDidMount: () ->
    $.getJSON "http://testapi.blockapps.net/query/block/number/#{@props.number}", (result, textStatus, jqXHR) =>
      @setState(block: result[0])

  render: () ->
    activities = []

    data = ""
    key = -1

    block = if @state.block? then @state.block.blockData else {}

    if @state.block?
      for transaction in @state.block.receiptTransactions
        key += 1
        activities.push <Activity key={key} type={transaction.transactionType}  transaction={transaction} block={block}/>

      data = <pre className="twelve columns" dangerouslySetInnerHTML={{__html: JSON.stringify(block, null, 2)}}></pre>

    <div className="block-view">
      <div className="container">
        <h1 className="twelve columns">
          Block{'\u00A0'}<span id="address_entered">#{@props.number}</span>
        </h1>

        <div className="five columns">
          {block.gasUsed || "..."}
          <br/><span className="label">Gas Used</span>
        </div>
        <div className="four columns">
          {block.difficulty || "..."}
          <br/><span className="label">Difficulty</span>
        </div>
        <div className="two columns">
          <span data-livestamp={if block? then new Date(block.timestamp).getTime() / 1000 else ""}></span>
          <br/><span className="label">Date Mined</span>
        </div>

        <h4 className="twelve columns">Transactions</h4>
        {if activities.length == 0 then "No transactions found for this block." else activities}
        <h4 className="twelve columns">Block Data</h4>
        {data}
      </div> 
    </div>



window.BlockView = BlockView