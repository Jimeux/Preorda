/** @jsx React.DOM */

var CSSTransitionGroup = React.addons.CSSTransitionGroup;

var ItemSlider = React.createClass({

  getInitialState: function() {
    return {
      page:     1,
      items:    [],
      vPadding: 50,
      backDisabled: 'disabled',
      forwardDisabled: ''
    };
  },

  pageUp: function(e) {
    e.preventDefault();
    this.handlePageChange(true);
  },

  pageDown: function(e) {
    e.preventDefault();
    this.handlePageChange(false);
  },

  componentDidMount: function() {
    var cHeight = this.refs.content.getDOMNode().offsetHeight;
    this.setState({vPadding: parseInt(cHeight / 2 - 55, 10)});
  },

  handlePageChange: function(goForward) {
    if (goForward  && this.state.forwardDisabled !== '') return;
    if (!goForward && this.state.backDisabled    !== '') return;

    var self = this;
    var nextPage = goForward ? this.state.page+1 : this.state.page-1;

    this.setState({
      backDisabled: nextPage <= 0 ? 'disabled' : ''
    });

    if (nextPage <= 0) return;

    $.get('departments.json?page=' + nextPage + '&id=' + this.props.id, function(items) {
      if (items.length > 0) {
        self.setState({items: items, page: nextPage, forwardDisabled: ''});
      } else {
        self.setState({items: self.state.items, page: self.state.page, forwardDisabled: 'disabled'});
      }
    });
  },

  render: function() {
    var items = this.state.items.map(function(item) {
      return (<PreviewItem key={item.url} item={item} />);
    });

    var content = items.length > 0 ?
        items : <div dangerouslySetInnerHTML={{__html: this.props.initialContent}} />;
    var linkStyle = {paddingTop: this.state.vPadding, paddingBottom: this.state.vPadding};

    return (
        <div>
          <div className="col-xs-1 chevron">
            <a href="#" className={this.state.backDisabled} onClick={this.pageDown} style={linkStyle}>
              <i className="glyphicon glyphicon-chevron-left"></i>
            </a>
          </div>

          <div className="col-xs-10" ref="content" style={{padding: 0, width: '88%'}}>
            {content}
          </div>

          <div className="col-xs-1 chevron">
            <a href="#" className={this.state.forwardDisabled} onClick={this.pageUp} style={linkStyle}>
              <i className="glyphicon glyphicon-chevron-right"></i>
            </a>
          </div>
        </div>
    );
  }
});

var PreviewItem = React.createClass({
  render: function () {
    var item = this.props.item;
    var variation = item.variation ? <div className="variation-caption">{item.variation}</div>          : '';
    var creator   = item.creator   ? <div className="dept-item-creator text-muted">{item.creator}</div> : '';

    return (
        <div key={'item'+(new Date().getTime())} className="dept-item col-xs-6 col-sm-4 col-md-2">
          <div>
            <a href={item.url}>
              {variation}
              <img src={item.image_url} className="dept-item-img" width="95" height={item.image_height} />
            </a>
          </div>
          <div className="dept-item-title"><a href={item.url}>{item.title}</a></div>
          {creator}
          <div className="dept-item-creator text-muted">{item.platform}</div>
          <div className="dept-item-date">{item.release_date}</div>
          <div className="dept-item-price" dangerouslySetInnerHTML={{__html: item.price}}></div>
        </div>
    );
  }
});

$(document).on('page:change', attachSliders);

function attachSliders() {
  $('.dept-panel').each(function () {
    var $container = $(this).find('.preview-items');
    var content = $container.html();
    $container.parent().css({paddingLeft: 0, paddingRight: 0});

    React.render(
        <ItemSlider dept={$(this).data('name')} id={$(this).data('id')} initialContent={content} />,
        $container[0]
    );
  });
}

//<CSSTransitionGroup transitionName={this.transitionName} style={{position: 'relative', overflow: 'hidden', display: 'block'}}>
//</CSSTransitionGroup>
//this.transitionName = 'carousel';
//this.transitionName = 'carousel-right';