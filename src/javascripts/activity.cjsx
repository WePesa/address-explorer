Activity = React.createClass
  credit: (str) ->
    return <span>{str}</span>

  debit: (str) ->
    return <span>-{str}</span>

  addressLink: (address, shortened=false) -> 
    return "" if !address?
    # Handle old-style addresses.
    if typeof address == "object" 
      address = address.address

    url = "index.html?#{address}"
    text = if !shortened then address else address.substring(0, 10)
    return <a className='address' href={url}>{text}</a>

  blockLink: (number) ->
    return <a href={"?" + number}>{@props.block.blockData.number}</a>

  render: () ->
    # Pretty gross detection of zero value. Another reason why this needs
    # an Ether class.
    value_object = Utils.prettyAmountAsObject(@props.block.blockData.gasUsed)
    if value_object.value != "0"
      value = "-" + Utils.prettyAmount(@props.block.blockData.gasUsed)
    else
      value = Utils.prettyAmount(@props.block.blockData.gasUsed)

    extra = ""
    timestamp = new Date(@props.block.blockData.timestamp)

    color = "turquoise"

    BLOCK_REWARD = 1500000000000000000 #wei

    switch @props.type
      when "Transfer"
        transaction = @props.transaction
        value = Utils.prettyAmount(transaction.value)

        if !@props.address?
          extra = <span>to<span dangerouslySetInnerHTML={{__html: '&nbsp;'}} />{@addressLink(transaction.to, true)}<span dangerouslySetInnerHTML={{__html: '&nbsp;'}} />from<span dangerouslySetInnerHTML={{__html: '&nbsp;'}} />{@addressLink(transaction.from, true)}</span>
        else if transaction.to != @props.address
          type = "Debit"
          value = @debit(value)
          extra = <span>to<span dangerouslySetInnerHTML={{__html: '&nbsp;'}} />{@addressLink(transaction.to)}</span>
          color = "red"
        else
          type = "Credit"
          value = @credit(value)
          extra = <span>from<span dangerouslySetInnerHTML={{__html: '&nbsp;'}} /><span dangerouslySetInnerHTML={{__html: '&nbsp;'}} />{@addressLink(transaction.from)}</span>

      when "Contract"
        color = "yellow"

      when "Mined"
        extra =  <span>Block #{@blockLink(@props.block.blockData.number)}</span>
        value = Utils.prettyAmount(BLOCK_REWARD)

      when "FunctionCall"
        value = value
        color = "white"

    <div className="activity ten columns offset-by-one">
      <span className={'type ' + color}>{@props.type}</span>
      <span className={'gas ' + color} ref="gas">{value}</span>
      <span className='extra'>{extra}</span>
      <span className='timestamp' data-livestamp={timestamp.getTime() / 1000}></span>
    </div> 

  afterRender: () ->
    setTimeout () =>
      gas = React.findDOMNode(@refs.gas)
      gas = $(gas)
      gas.textFit {
        widthOnly: true
        reProcess: true
        maxFontSize: 15
      }
    , 50

  componentDidMount: () ->
    @afterRender()

  componentDidUpdate: () ->
    @afterRender()

window.Activity = Activity