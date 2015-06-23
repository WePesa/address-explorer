class Utils
  # TODO: Rename this. Probably should create an Ether class for these in the future.
  @prettyAmountAsObject: (wei) ->
    wei = new BigNumber(wei.toString())

    if wei.toString(10) == "0"
      return {
        value: "0"
        denomination: "wei"
      }

    denominations = ["wei", "Kwei", "Mwei", "Gwei", "szabo", "finney", "Ether", "Kether", "Mether", "Gether", "Tether"]
    denomination = 0
    factor = 1

    while wei >= factor and denomination < denominations.length
      denomination += 1
      factor *= 1000

    denomination = denominations[denomination - 1]
    factor = factor / 1000
 
    value = wei.dividedBy(factor).toFixed(2) + ""
    value = value.substring(0, value.length - 3) if value.indexOf(".00") == value.length - 3

    return {value, denomination}

  @prettyAmount: (wei) ->
    pretty_object = Utils.prettyAmountAsObject(wei)

    return "#{pretty_object.value} #{pretty_object.denomination}"

  @shortDenomination: (denomination) ->
    if denomination[0] == "K" or denomination[0] == "M" or denomination[0] == "G" or denomination[0] == "T"
      return denomination.substring(0,4)
    return denomination.substring(0,3)

window.Utils = Utils