$(document).on "ready", () ->

  BLOCK_REWARD = 1500000000000000000 #wei

  prettyAmount = (wei) ->
    wei = new BigNumber(wei.toString())

    return "0 wei" if wei == 0

    denominations = ["wei", "Kwei", "Mwei", "Gwei", "szabo", "finney", "Ether"]
    denomination = 0
    factor = 1

    while wei >= factor
      denomination += 1
      factor *= 1000

    denomination = denominations[denomination - 1]
    factor = factor / 1000

    value = wei.dividedBy(factor).toFixed(2) + ""
    value = value.substring(0, value.length - 3) if value.indexOf(".00") == value.length - 3

    return "#{value} #{denomination}"

  credit = (str) ->
    return "<span class='green'>#{str}</span>"

  debit = (str) ->
    return "<span class='red'>-#{str}</span>"

  addressLink = (address) ->
    return "<a class='address' href='index.html?#{address}'>#{address}</a>"

  addressView = $("#address_view")
  accountView = $("#account_view")

  showView = (view) ->
    $(".view").removeClass "visible"
    $(".view").addClass "hidden"
    view.removeClass "hidden"
    view.addClass "visible"

  # Address View elements
  addressInput = $("#address")
  viewAccountButton = $("#view_account")

  # Account View elements
  addressEntered = $("#address_entered")
  displayedBalance = $("#displayed_balance")
  transactionCount = $("#transaction_count")
  blocksMinedCount = $("#blocks_mined_count")

  refreshButton = $("#refresh")
  
  addActivity = (type, block, transaction) ->
    timestamp = new Date(block.timestamp)
    value = prettyAmount(block.gasUsed)

    # Just in case I made a mistake, make things blank.
    icon = "&nbsp;"
    extra = "&nbsp;"

    if transaction? and type == "Transfer"
      value = prettyAmount(transaction.value)
      if transaction.to != addressInput.val()
        icon = "&larrb;"
        type = "Debit"
        value = debit(value)
        extra = "to #{addressLink(transaction.to)}" 
      else
        icon = "&rarrpl;"
        type = "Credit"
        value = credit(value)
        extra = "from #{addressLink(transaction.from)}"
    
    if type == "Contract"
      icon = "X" 
      value = "-" + value

    if type == "Mined"
      icon = "&nwnear;"
      extra = "Block ##{block.number}"
      value = prettyAmount(BLOCK_REWARD)

    if type == "FunctionCall"
      icon = "&DDotrahd;" 
      value = "-" + value

    element = $(document.createElement "div")
    element.data("timestamp", timestamp.getTime())
    element.addClass "transaction eleven columns"
    
    element.append "<span class='icon small'>#{icon}</span>"
    element.append "<span class='type'>#{type}</span>"
    element.append "<span class='gas'>#{value}</span>"
    element.append "<span class='extra'>#{extra}</span>"
    element.append "<span class='timestamp' data-livestamp='#{timestamp.getTime() / 1000}'>&nbsp;</span>"

    # Keep DOM elements sorted.
    elements = accountView.find(".transaction").detach().get()

    elements.push element

    elements = elements.sort (a,b) ->
      a = parseInt($(a).data("timestamp"))
      b = parseInt($(b).data("timestamp"))
      return b - a

    accountView.find(".container").append(elements)
    
  showAccount = (address) ->
    addressInput.val(address)
    addressEntered.html("(#{address.substring(0,16)}...)")
    showView(accountView)
    refresh()

  refresh = () ->
    $(".transaction").remove()

    displayedBalance.html("...")
    transactionCount.html("...")
    blocksMinedCount.html("...")

    address = addressInput.val()

    getBlock = (txType, blockId, transaction) ->
      ((txType, blockId, transaction) -> 
        $.getJSON "http://api.blockapps.net/query/block/blockid/#{blockId}", (result, textStatus, jqXHR) ->
          addActivity(txType, result[0], transaction)
      )(txType, blockId, transaction)

    $.getJSON "http://api.blockapps.net/query/account/address/#{address}", (statuses, textStatus, jqXHR) ->
      displayedBalance.html(prettyAmount(statuses[0].balance))

    # We could save some time by doing the next two requests in parallel,
    # but for simplicity let's just do them in series for now.
    $.getJSON "http://api.blockapps.net/query/block/coinbase/#{address}", (blocks, textStatus, jqXHR) ->
      blocksMinedCount.html(blocks.length)

      for block in blocks
        addActivity("Mined", block.blockData) 

    $.getJSON "http://api.blockapps.net/query/transaction/address/#{address}", (transactions, textStatus, jqXHR) ->
      transactionCount.text(transactions.length)
      
      for transaction in transactions
        if transaction.transactionType == "JustTheSig"
          console.log transaction
          continue
        getBlock(transaction.transactionType, transaction.blockId, transaction)

  refreshButton.on "click", () ->
    refresh()

  viewAccountButton.on "click", () ->
    address = addressInput.val()
    showAccount(address)

  if window.location.search != ""
    address = window.location.search.substring(1)
    showAccount(address)
    


    
    