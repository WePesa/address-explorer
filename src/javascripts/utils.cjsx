class Utils
  @prettyAmount: (wei) ->
    wei = new BigNumber(wei.toString())

    return "0 wei" if wei == 0

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

    return "#{value} #{denomination}"

window.Utils = Utils