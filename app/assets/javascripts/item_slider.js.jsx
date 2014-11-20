/** @jsx React.DOM */

var ItemSlider = React.createClass({

  getInitialState: function() {
    return {
      page:     1,
      vPadding: 50,
      backDisabled: 'disabled',
      forwardDisabled: '',
      content: this.props.initialContent
    };
  },

  pageUp: function(e) {
    if (typeof e != 'undefined') e.preventDefault();
    this.handlePageChange(true);
  },

  pageDown: function(e) {
    if (typeof e != 'undefined') e.preventDefault();
    this.handlePageChange(false);
  },

  componentDidMount: function() {
    this.hammer = new Hammer(this.getDOMNode());
    this.hammer.on('swiperight', this.pageDown);
    this.hammer.on('swipeleft',  this.pageUp);

    window.addEventListener("resize", this.setHeight);
    this.setHeight();
    this.cache = [this.props.initialContent];
  },

  componentWillUpdate: function() {
    // This sets the padding for .panel-body
    var padding = window.outerWidth < 500 ? 0 : 10;
    $(this.getDOMNode().parentNode.parentNode)   //TODO: Use a class or media queries for this
        .css({paddingLeft: padding, paddingRight: padding});

    //$(this.refs.content.getDOMNode())
    //    .css('opacity', 0.45)
    //    .animate({opacity: 1.0}, 250);
  },

  setHeight: function() {
    var cHeight = this.refs.content.getDOMNode().offsetHeight;
    this.setState({
      vPadding: parseInt(cHeight / 2 - 55, 10)
    });
  },

  handlePageChange: function func(goForward) {
    if (goForward  && this.state.forwardDisabled !== '') return;
    if (!goForward && this.state.backDisabled    !== '') return;

    var nextPage = goForward ? this.state.page+1 : this.state.page-1;
    var backDisabled = nextPage <= 0 ? 'disabled' : '';

    if (nextPage <= 0) {
      this.setState({
        backDisabled: backDisabled
      });
      return;
    }

    if (typeof this.cache[nextPage-1] != 'undefined') {
      this.setState({
        content: this.cache[nextPage-1],
        page: nextPage,
        forwardDisabled: '',
        backDisabled: backDisabled});
    } else {
      this.loadData(nextPage, backDisabled);
    }
  },

  loadData: function(nextPage, backDisabled) {
    var self = this;
    //$(self.refs.content.getDOMNode()).animate({opacity: 0.25}, 250);
    $.get('departments.json?page=' + nextPage + '&id=' + this.props.id, function(data) {
      if ($(data.content).find('.dept-item-title').length >= 1) {
        var content = $(data.content).html();
        self.cache[nextPage-1] = content;
        self.setState({content: content, page: nextPage, forwardDisabled: '', backDisabled: backDisabled});
      } else {
        self.setState({content: self.state.content, page: self.state.page, forwardDisabled: 'disabled', backDisabled: backDisabled});
      }
    });
  },

  render: function() {
    var xs  = (window.outerWidth < 500);
    var linkStyle = {paddingTop: this.state.vPadding, paddingBottom: this.state.vPadding};

    return (
        <div>
          <div className="col-xs-1 chevron" style={{width: xs ? '10%' : '6%'}}>
            <a href="#" className={this.state.backDisabled} onClick={this.pageDown} style={linkStyle}>
              <i className="glyphicon glyphicon-chevron-left"></i>
            </a>
          </div>

          <div className="col-xs-10"
               ref="content"
               style={{padding: 0, width: xs ? '80%' : '88%'}}
               dangerouslySetInnerHTML={{__html: this.state.content}}>
          </div>

          <div className="col-xs-1 chevron" style={{width: xs ? '10%' : '6%'}}>
            <a href="#" className={this.state.forwardDisabled} onClick={this.pageUp} style={linkStyle}>
              <i className="glyphicon glyphicon-chevron-right"></i>
            </a>
          </div>
        </div>
    );
  }
});

function attachSliders() {
  $('.dept-preview').each(function () {
    var $container = $(this).find('.preview-items');
    var content = $container.html();

    React.render(
        <ItemSlider dept={$(this).data('name')} id={$(this).data('id')} initialContent={content} />,
        $container[0]
    );
  });
}

$(document).on('page:change', attachSliders);