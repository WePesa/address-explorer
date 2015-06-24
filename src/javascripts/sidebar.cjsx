Sidebar = React.createClass
  render: () ->
    itemClasses = [
      "first"
      "second"
      "third"
    ]

    itemIndex = -1

    if @props.buttonAction?
      logoClassName = "logo"
    else
      logoClassName = "logo without-button"

    <div className="sidebar">
      <a href="http://blockapps.net"><div className={logoClassName}></div></a>
      {
        @props.items.map (item) ->
          itemIndex += 1
          return <div ref={"item" + itemIndex} className={"item " + itemClasses[itemIndex]}>
            <div className="name">{item.name}</div>
            {
              if item.string?
                <div className="string">{item.string}</div>
            }
            {
              if item.image? 
                <div className={"image " + item.image}></div>
            }
            <div className="value">{item.value}</div>
          </div>
      } 
      <div className="buttons">
        {
          if @props.searchButtonName? 
            <button className="darkturq" onClick={@props.searchButtonAction}>
              {@props.searchButtonName}
            </button>
          else
            ""
        }
        {
          if @props.buttonAction? 
            <button className="darkturq second" onClick={@props.buttonAction}>
              {@props.buttonName}
            </button>
          else
            ""
        }
      </div>
    </div>

  afterRender: () ->
    # Supports up to three items.
    for index in [0..2]
      item = React.findDOMNode(@refs["item" + index])
      item = $(item)
      value = $(item.find(".value"))
      value.textFit {
        widthOnly: true
        reProcess: true
        maxFontSize: 40
        detectMultiLine: false
      }

  componentDidMount: () ->
    @afterRender()

  componentDidUpdate: () ->
    @afterRender()

window.Sidebar = Sidebar