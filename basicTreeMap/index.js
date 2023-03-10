class Chart {
    constructor(){
        this._width = 600;
        this._height = 400;
        this._margins = {top:30, left:30, right:30, bottom:30};
        this._data = [];
        this._scaleX = null;
        this._scaleY = null;
        this._colors = d3.scaleOrdinal(d3.schemeCategory10);
        this._box = null;
        this._svg = null;
        this._body = null;
        this._padding = {top:10, left:10, right:10, bottom:10};
    }

    width(w){
        if (arguments.length === 0) return this._width;
        this._width = w;
        return this;
    }

    height(h){
        if (arguments.length === 0) return this._height;
        this._height = h;
        return this;
    }

    margins(m){
        if (arguments.length === 0) return this._margins;
        this._margins = m;
        return this;
    }

    data(d){
        if (arguments.length === 0) return this._data;
        this._data = d;
        return this;
    }

    scaleX(x){
        if (arguments.length === 0) return this._scaleX;
        this._scaleX = x;
        return this;
    }

    scaleY(y){
        if (arguments.length === 0) return this._scaleY;
        this._scaleY = y;
        return this;
    }

    svg(s){
        if (arguments.length === 0) return this._svg;
        this._svg = s;
        return this;
    }

    body(b){
        if (arguments.length === 0) return this._body;
        this._body = b;
        return this;
    }

    box(b){
        if (arguments.length === 0) return this._box;
        this._box = b;
        return this;
    }

    getBodyWidth(){
        let width = this._width - this._margins.left - this._margins.right;
        return width > 0 ? width : 0;
    }

    getBodyHeight(){
        let height = this._height - this._margins.top - this._margins.bottom;
        return height > 0 ? height : 0;
    }

    padding(p){
        if (arguments.length === 0) return this._padding;
        this._padding = p;
        return this;
    }

    defineBodyClip(){

        this._svg.append('defs')
                 .append('clipPath')
                 .attr('id', 'clip')
                 .append('rect')
                 .attr('width', this.getBodyWidth() + this._padding.left + this._padding.right)
                 .attr('height', this.getBodyHeight() + this._padding.top  + this._padding.bottom)
                 .attr('x', -this._padding.left)
                 .attr('y', -this._padding.top);
    }

    render(){
        return this;
    }

    bodyX(){
        return this._margins.left;

    }

    bodyY(){
        return this._margins.top;
    }

    renderBody(){
        if (!this._body){
            this._body = this._svg.append('g')
                            .attr('class', 'body')
                            .attr('transform', 'translate(' + this.bodyX() + ',' + this.bodyY() + ')')
                            .attr('clip-path', "url(#clip)");
        }

        this.render();
    }

    renderChart(){
        if (!this._box){
            this._box = d3.select('body')
                            .append('div')
                            .attr('class','box');
        }

        if (!this._svg){
            this._svg = this._box.append('svg')
                            .attr('width', this._width)
                            .attr('height', this._height);
        }

        this.defineBodyClip();

        this.renderBody();
    }

}


d3.json('data.json').then(function(data){

    /* ----------------------------????????????------------------------  */
    const chart = new Chart();
    const config = {
        margins: {top: 80, left: 80, bottom: 50, right: 80},
        textColor: 'black',
        title: '????????????',
        hoverColor: 'white',
        animateDuration: 1000
    }

    chart.margins(config.margins);
    
    /* ----------------------------????????????------------------------  */
    const root = d3.hierarchy(data)
                    .sum((d) => d.house)
                    .sort((a,b) => a.value - b.value);

    const generateTreeMap = d3.treemap()
                    .size([chart.getBodyWidth(), chart.getBodyHeight()])
                    .round(true)
                    .padding(1);
    
    generateTreeMap(root);
    
    /* ----------------------------????????????------------------------  */
    chart.renderRect = function(){
        const cells = chart.body().selectAll('.cell')
                                    .data(root.leaves());
                
              cells.enter()
                     .append('g')
                     .attr('class', (d, i) => 'cell cell-' + i)
                     .append('rect')
                   .merge(cells)
                     .attr('x', (d) => d.x0)
                     .attr('y', (d) => d.y0)
                     .attr('width', (d) => d.x1 - d.x0)
                     .attr('height', (d) => d.y1 - d.y0)
                     .attr('fill', (d,i) => chart._colors(i % 10));
            
              cells.exit()
                    .remove();     
    }

    /* ----------------------------??????????????????------------------------  */
    chart.renderText = function(){

        const texts = d3.selectAll('.cell')
                            .append('text');
              texts
                .attr('class', 'cell-text')
                .attr('transform', (d) => 'translate(' + (d.x0+d.x1)/2 + ',' + (d.y0+d.y1)/2 + ')' )
                .text((d) => d.data.name)
                .attr('stroke', config.textColor)
                .attr('fill', config.textColor)
                .attr('text-anchor', 'middle')
                .text( function(d){
                    if (textWidthIsOk(d, this)){
                        return d.data.name;
                    }else{
                        return '...';
                    }
                })
        
        // ??????????????????????????????
        function textWidthIsOk(d, text){
            const textWidth = text.getBBox().width;
            if ((d.x1-d.x0) >= textWidth) return true;
            return false;
        }

    }

    /* ----------------------------???????????????------------------------  */
    chart.renderTitle = function(){
        chart.svg().append('text')
                .classed('title', true)
                .attr('x', chart.width()/2)
                .attr('y', 0)
                .attr('dy', '2em')
                .text(config.title)
                .attr('fill', config.textColor)
                .attr('text-anchor', 'middle')
                .attr('stroke', config.textColor);

    }

    /* ----------------------------????????????????????????------------------------  */
    chart.addMouseOn = function(){

        d3.selectAll('.cell rect')
            .on('mouseover', function(){
                const e = d3.event;
                e.target.style.cursor = 'hand'

                d3.select(e.target)
                    .attr('fill', config.hoverColor);
                
            })
            .on('mouseleave', function(d,i){
                const e = d3.event;
                
                d3.select(e.target)
                    .attr('fill', chart._colors(i % 10));
            });
    }
        
    chart.render = function(){

        chart.renderTitle();

        chart.renderRect();

        chart.renderText();

        chart.addMouseOn();
    }

    chart.renderChart();
    
        
});














