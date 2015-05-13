$(document).on("ready", function() {
  console.log("Address Explorer JS up and running.");
  var address = window.location.search.substring(1);
  console.log("Address: " + address);

  // Get the account balance.
  $.getJSON("http://api.blockapps.net/query/account/address/" + address, function(balances, textStatus, jqXHR) {
    $("#displayed_balance").html(balances[0].balance);
  });

  var addActivity = function(timestamp, message) {
    var date = new Date(timestamp);
    var element = $(document.createElement("div"));
    element.addClass("transaction twelve columns");
    element.html(date.toISOString() + " &mdash;  " + message);
    element.data("date", date.getTime());

    // Keep DOM elements ordered by date.
    var elements = $(".transaction").detach().get();
    elements.push(element);
    elements = elements.sort(function(a,b) {
      a = parseInt($(a).data("date"));
      b = parseInt($(b).data("date"));
      return b - a;
    });
    $(".container").append(elements);
  };

  // Function for getting individual blocks.
  var createTransactionHandler = function(transaction) {
    return function (result, textStatus, jqXHR) {
      block = result[0];

      switch (transaction.transactionType) {
        case "Contract":
          addActivity(block.timestamp, "New contract added to the network at cost of " + block.gasUsed + " wei.");
          break;
        case "FunctionCall":
          addActivity("Function call to contract at cost of " + block.gasUsed + " wei.");
          break;
        case "Transfer":
          if (transaction.to == address) {
            addActivity(block.timestamp, "Credit of " + transaction.value + " wei sent from " + transaction.from + ".");
          } else {
            addActivity(block.timestamp, "Debit of " + transaction.value + " wei sent to " + transaction.to + ".");
          }
          break;
        default:
          return;
      }
    };
  };

  // Get each transaction, and get each block associated with the transaction.
  $.getJSON("http://api.blockapps.net/query/transaction/address/" + address, function(transactions, textStatus, jqXHR) {
      $("#transaction_count").text(transactions.length);
      
      for (var i = 0; i < transactions.length; i++) {
        var transaction = transactions[i];
        $.getJSON("http://api.blockapps.net/query/block/blockid/" + transaction.blockId, createTransactionHandler(transaction));
      }
  });

  // Get blocks mined by the address.
  $.getJSON("http://api.blockapps.net/query/block/coinbase/" + address, function(blocks, textStatus, jqXHR) {
      $("#blocks_mined_count").html(blocks.length)

      for (var i = 0; i < blocks.length; i++) {
        var block = blocks[i];
        addActivity(block.blockData.timestamp, "Mined block #" + block.blockData.number + " with a block reward of 1500000000000000000 wei."); 
      }
  });
});