<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page language="java" %>
<%@ page import="com.mysql.jdbc.Driver" %>

<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<style>
	div{
			background: #F2F4FF;
			width: 100px;
			height: 40px;
			position: absolute;
			opacity: 0;
			text-align: center;
			font-size: 10px;
			line-height: 40px;
		}
	</style>	
</head>
	
<script src="https://d3js.org/d3.v4.min.js"></script>
<body>
	<p align="center" style="font-size: 20px;">单词数据库中词性统计</p>
	<p align="center" style="font-size: 12px;">19数科姜力菲</p><br>
	<svg id="histSvg" style="position: relative; left: 28%;" width="600" height="500" ></svg>
	<br><br><br>
<% 
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url="jdbc:mysql://localhost/eng?characterEncoding=UTF-8&serverTimezone=GMT%2B8&useSSL=false";  
        String username="root";   //登录账号
        String password="123456";  //登录密码
        Connection conn=DriverManager.getConnection(url,username,password);
   
   		Statement stmt = null;  
        ResultSet rs = null;  
        //String sql = "SELECT *FROM map_enword order by english;";  //查询语句
        stmt = conn.createStatement();  
        //rs = stmt.executeQuery(sql);
   
   		//out.print(sql);

   		int[] count=new int[26];
   	
   		for(int i=0;i<26;i++)
		{
			int aa=Integer.valueOf('a')+i;
			char cha = (char) aa;
			
			String sql1="SELECT * FROM map_enword where chinese like '"+cha+"%' "+"order by english"; 
	
			rs = stmt.executeQuery(sql1);  // 输出每一个数据值 
			String str;
			int j=0;
			while(rs.next()) 
			{ 
				str=(rs.getString(2)).substring(0,1);
				j++;
				count[i]=j;
			}
			
		//out.print(" "+j+" <br>");
	
		rs.close(); }
	
		stmt.close(); 
		conn.close();
%>


<script>
	  	var dataset =new Array(26);
		<%   
	   		for(int i=0;i <count.length;i++){   %> 
			dataset[ <%=i%> ]= " <%=count[i]%> ";
		<% } %>
					
		var finaldata =new Array();
					
		var z=0;
		for(var i=0;i<dataset.length;i++){ 
			if(dataset[i]>0)
			{
				finaldata[z]=dataset[i];
				z++;
			}
		}	
	
	const colorScale = ["#5f45ff", "#97ABFF",  "#EEDC82", "#FFEFD5","#d5d6d8","#FFDAB9"];
	
	var hist=document.getElementById("histSvg");

		var myRect=new Array();
        var gdpName=new Array(6);
        var PName=new Array(6);
        
        var content=new Array("形容词/副词","连词","感叹词","名词","介词","动词");
    
		for(var i=0;i<6;i++){
			console.log(i);
			myRect[i]=document.createElement("rect");
			hist.appendChild(myRect[i]);
          
            gdpName[i]=document.createElement("text");
            hist.appendChild(gdpName[i]);
          
            PName[i]=document.createElement("text");
            hist.appendChild(PName[i]);

            
            var h=parseInt(finaldata[i])/7;
			var CC=colorScale[i];
 
            myRect[i].outerHTML="<rect x="+(i*90)+" y="+(470-h)+" rx=5 ry=5 width=80 height="+h+" style='fill:"+CC+" '/>";
			
            gdpName[i].outerHTML="<text x="+(i*96)+" y="+(465-h)+" style='font-family:微软雅黑;fill:rgb(0,0,0);font-size:11'> "+finaldata[i]+" </text>";
			
            PName[i].outerHTML="<text x="+(i*96)+" y=490 style='font-family:微软雅黑;fill:rgb(0,0,0);font-size:14'> "+content[i]+" </text>";
        }
	
	
	
	var dataset =new Array(26);
		<%   
	   		for(int i=0;i <count.length;i++){   %> 
			dataset[ <%=i%> ]= " <%=count[i]%> ";
		<% } %>
					
		var finaldata =new Array();
					
		var z=0;
		for(var i=0;i<dataset.length;i++){ 
			if(dataset[i]>0)
			{
				finaldata[z]=dataset[i];
				z++;
			}
		}			
				
		
	  	var ADD=Number(finaldata[1])+Number(finaldata[2])+Number(finaldata[4]);
		// 数据准备
		let data = [ {label: '形容词/副词', num: finaldata[0]}, 
					{label:'名词', num: finaldata[3]},  
					{label: '动词', num: finaldata[5]},
				   	{label: '其他（连词/感叹词/介词）', num: ADD}];
		let marge = {top: 0, right: 60, bottom: 60, left: 0};
		var width=(window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth)*0.97;
		var height=(window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight)*0.88;
		
		// 弧形生成器内、外半径
		let innerRadius = 140, outerRadius = 210;
		let svg = d3.select('body').append('svg').attr('width', width).attr('height', height);
		let g = svg.append('g').attr('transform', 'translate(' + marge.left + ',' + marge.top  + ')');
		
		//const colorScale = ["#5f45ff", "#97ABFF",  "#EEDC82", "#FFEFD5","#d5d6d8"];
		
		svg.append("text")
				   .attr("x",2*width/5)
				   .attr("y",height/2-20)
				   .attr("text-anchor","middle")
				   .attr("font-size",20)
				   .text('单词数据库中');
		svg.append("text")
				   .attr("x",2*width/5)
				   .attr("y",height/2+20)
				   .attr("text-anchor","middle")
				   .attr("font-size",20)
				   .text('各类单词占比（%）');
		
		// 创建饼状图
		let pie = d3.pie().value(function(d) {return d.num}).sort(null);
		
		// 创建弧形生成器
		let arc = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius);
		let arc2 = d3.arc().innerRadius(innerRadius).outerRadius(outerRadius + 30);
		// 饼状图生成器转换数据
		let pieData = pie(data);
		
		// 开始绘制，先为每个扇形及其对应的文字建立一个分组<g>
		let arcs = g.selectAll('.g').data(pieData).enter().append('g').attr('cursor', 'pointer')
			.attr('transform', 'translate(' + 2*width/5 + ',' + height/2 + ')');
		
		
		// 绘制饼状图的各个扇形
		arcs.append('path')
			.transition()
			.delay(0)
			.duration(500)
			//.each(d3.easeBounceInOut)
			.attrTween('d', function(d, i) {
				let interpolate = d3.interpolate(d.startAngle, d.endAngle);
				return function(t) {
					d.endAngle = interpolate(t);
					return arc(d);
				}
			})
			.attr('fill', function(d, i) {
				d.color =colorScale[i];
				return d.color;
			});
		
		// 绘制饼状图上的文字信息
		arcs.append('text')
			.attr('transform', function(d) {
				return 'translate(' + arc.centroid(d) + ')';
			})
			.attr('text-anchor', 'middle')
			.attr("font-size","10px")
			.text(function(d) {
				return ((d.endAngle - d.startAngle) / 6.283185307179586 * 100).toFixed(2) + '%';
			});
		
		
			
		let label=svg.selectAll('.label')      //添加右上角的标签
			.data(pieData)
			.enter()
			.append('g')
			.attr("transform","translate(" + (width /3 + outerRadius * 2) + "," + 80 + ")");
		
		label.append('rect')        //标签中的矩形
			.style('fill',function(d,i){
				return colorScale[i];
			})
			.attr('x', 0)
			.attr("y",function(d,i){
				return (height - outerRadius) / 2 + (i - 1) * 30;
			})
			.attr('rx','10')     //rx=ry 会出现圆角
			.attr('ry','10')
			.attr('width',50)
			.attr('height',20);
		
		label.append('text')            //标签中的文字
			.attr('x',function(d,i){
				return 65;              //因为rect宽度是50，所以把文字偏移15,在后面再将文字设置居中
			})
			.attr("y",function(d,i){        
				return (height - outerRadius) / 2 + 15 + (i - 1) * 30;
			})
			.text(function(d){
				return d.data.label;
			})
			.style({
				"font-size":"10px",
				"text-anchor":"middle",
				'fill':"white",
				"font-weight":600
			});
 
		// 文字是否超出扇形区域(超出返回true，不超出返回false)
		function overRange(d) {
			// 扇形长度（不是弧长，是从扇形左边的中间位置引出的一条水平线与右边相交的直线长度）
			// 计算公式：扇形半径/2 * sin(弧度)
			let length = (outerRadius / 2) * Math.sin(d.endAngle - d.startAngle);
			// 字符串长度
			let len = getStrLen(d.data.label);
			if (len >= length) {
				return true;
			}
			return false;
		}
		
		
		// 悬浮提示框
		var tooltip = d3.select('body').append('div');
		
		arcs.on('mouseover', function() {
			//let label;
			d3.select(this)
				.select('path')
				.transition()
			
				.attr('d', function(d) {
				label = d.data.num;
				return arc2(d);
			})
			
		console.log('over');	
		// 悬浮在直方图上时，显示提示框
		tooltip.html(label).transition()
			.duration(100)
			.style('left', d3.event.pageX - 20)
			.style('top', d3.event.pageY + 20)
			.style('opacity', 1.0);
		});
		
	
		arcs.on('mouseout', function() {
			d3.select(this)
				.select('path').transition().attr('d', function(d) {
				return arc(d);
			});
			// 隐藏悬浮框
			tooltip.transition().style('opacity', 0);
		});
		
		
		// 获取字符串所占像素
		function getStrLen(val) {
			var len = 0;
			for (var i = 0; i < val.length; i++) {
				var length = val.charCodeAt(i);
				if(length >= 0 && length <= 128) {
					len += 1;
				}else {
                    len += 2;
                }
            }
            return len * 7.1;
        }

				
	</script>
</body>
	
<p align="center" style="font-size: 15px;"><br><br>根据可视化结果可以分析得知，在单词库中名词数量最多、其次是形容词/副词和动词，<br>而介词、连词、感叹词较少，尤其是感叹词只有不超过10个。<br>区分词性不仅可以帮助背单词时分类记忆，也可以加深对单词的理解掌握。</p><br>