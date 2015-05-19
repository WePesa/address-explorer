Activity = React.createClass
  credit: (str) ->
    return <span className='green'>{str}</span>

  debit: (str) ->
    return <span className='red'>-{str}</span>

  addressLink: (address, shortened=false) ->
    url = "index.html?#{address}"
    text = if !shortened then address else address.substring(0, 10)
    return <a className='address' href={url}>{address}</a>

  render: () ->
    icon = "X"
    value = Utils.prettyAmount(@props.block.gasUsed)
    extra = ""
    timestamp = new Date(@props.block.timestamp)

    BLOCK_REWARD = 1500000000000000000 #wei

    switch @props.type
      when "Transfer"
        transaction = @props.transaction
        value = Utils.prettyAmount(transaction.value)

        if !@props.address?
          icon = "\u21c4"
          extra = <span>to{'\u00A0'}{@addressLink(transaction.to, true)}{'\u00A0'}from{'\u00A0'}{@addressLink(transaction.from, true)}</span>
        else if transaction.to != @props.address
          icon = "\u21e4"
          type = "Debit"
          value = @debit(value)
          extra = <span>to{'\u00A0'}{@addressLink(transaction.to)}</span>
        else
          icon = "\u2945"
          type = "Credit"
          value = @credit(value)
          extra = <span>from{'\u00A0'}{@addressLink(transaction.from)}</span>

      when "Contract"
       icon = "X" 
       value = "-" + value

      when "Mined"
        icon = "\u2927"
        extra = "Block ##{@props.block.number}"
        value = Utils.prettyAmount(BLOCK_REWARD)

      when "FunctionCall"
        icon = "\u2911" 
        value = "-" + value

    <div className="activity twelve columns">
      <span className='icon small'>{icon}</span>
      <span className='type'>{@props.type}</span>
      <span className='gas'>{value}</span>
      <span className='extra'>{extra}</span>
      <span className='timestamp' data-livestamp={timestamp.getTime() / 1000}></span>
    </div> 

window.Activity = Activity