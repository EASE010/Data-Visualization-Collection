<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@ page language="java" %>
<%@ page import="com.mysql.jdbc.Driver" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>word</title>
    <!--<script src="d3.v3.min.js" charset="utf-8"></script>-->
	<script src="d3new.js" charset="utf-8"></script>
    <script src="js2wordcloud.min.js"></script>
	<style>
		path{
			  fill: none;
			  stroke: #666;
			  stroke-width: 1.5px;
			}
			
			 circle {
			  stroke: #333;
			  stroke-width: 1.5px;
			}
			 
			text {
			  font: 10px sans-serif;
			  pointer-events: none;
			}
			 
		.tooltip{  
				position: absolute;  
				width: 240px;  
				height: auto;  
				font-family: simsun;  
				font-size: 10px;
				text-align: left;  
				color: white;  
				border-width: 1px solid grey;  
				background-color: #000000;  
				border-radius: 3px; 
				padding: 7px;
				opacity: 0;
			}  

		.tooltip:after{   
				content: '';  
				position: absolute;  
				bottom: 100%;  
				left: 20%;  
				margin-left: -3px;  
				width: 0;  
				height: 0;  
				opacity: 0;
				padding: 7 px;
				border-bottom: 12px solid black;  
				border-right: 12px solid transparent;  
				border-left: 12px solid transparent;  
			} 
			
		.node {
  				border: solid 1px white;
  				font: 10px sans-serif;
  				color: azure;
  				line-height: 15px;
  				overflow: hidden;
  				position: absolute;
  				text-indent: 2px;
					}
	</style>
</head>
<body>

	<br>
	<!--
	<a href="https://cuc.yingshinet.com/CH12/renminWC.htm">
	
		<img style="width: 150px;height: 75px;position: absolute;left: 260px;top: 20px;" src="Hulusign.png"></a>
	<div id="headline" style="text-align: center; margin:15px auto;width: 500px;height: 40px;font-size: 27px;font-weight: 700;">烂番茄网站94部HULU评分最高剧集</div>
	<p style="" align="center">19数科 姜力菲</p>
	
	<br>-->
	
    <div id="cloud" style="margin:0 auto; width:1100px;height:370px;"></div><br><br>
	<!--<div style=" margin:30px auto;width: 850px;height: 400px;font-size: 17px;">Hulu是由NBC环球、新闻集团以及迪士尼联合投资的视频网站。Hulu的目标是帮助用户在任意时刻、地点及方式查找并欣赏专业的媒体内容。其内容包括电视剧、电影和剪辑，主要来自于超过200个内容提供商，包括福克斯、NBC、迪斯尼、ABC、华纳兄弟、米高梅公司、狮门公司和索尼等。<br>随着其2008年3月在美国的公开发布，Hulu已经被业界公认为最具前途的“在线体验电视的新途径”。<br><br><br>在知名影视评分网站“烂番茄”上，Hulu最受好评的剧集当属其于2021年发布的10集原创自制剧《公寓大楼里的谋杀案（Only Murders in the Building）》<br>这部设定在纽约的都市犯罪类喜剧在烂番茄上收获了100%的观众好评认证，截至目前，这部剧已经斩获了第79届金球奖电视类最佳音喜类剧集、第28届美国演员工会奖喜剧类剧集最佳群戏、第74届美国编剧工会奖喜剧类剧集最佳剧本、第12届美国评论家选择电视奖喜剧类最佳剧集等多项提名，并将在今年夏天继续对第74届黄金时段艾美奖喜剧类最佳剧集发起冲击。<br><br><br>除此之外，Hulu已经基本确定了今年将对艾美奖最佳限定类剧集发起冲击的阵容：《成瘾剂量（Dopesick）》、《帕姆与汤米（Pam and Tommy）》、《辍学生（The Dropout）》、《来自普赖恩维尔的女孩（The girl from Plainville）》、《坎迪（Candy）》、《聊天记录（Conversation with Friends）》</div>
	-->
	
	<% 
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url="jdbc:mysql://localhost/eng?characterEncoding=UTF-8&serverTimezone=GMT%2B8&useSSL=false";  
        String username="root";   //登录账号
        String password="123456";  //登录密码
        Connection conn=DriverManager.getConnection(url,username,password);
   
   		Statement stmt = null;  
        ResultSet rs1 = null;
        
        stmt = conn.createStatement();  

   		String[] NAME=new String[94];
	    int[] rate=new int[94];
   	
   		int i=0;int j=0;
		String sql1 = "SELECT name FROM hulu_rt;";  //查询语句1
	   	String sql2 = "SELECT rating FROM hulu_rt;";  //查询语句2
		
	   rs1 = stmt.executeQuery(sql1);  
			
		while(rs1.next()) 
		{ 
			NAME[i]=rs1.getString(1);
	   		i++;}
	   rs1.close();
	   
	   
	   ResultSet rs2 = stmt.executeQuery(sql2); 
	   
	   while(rs2.next()) 
		{ 
			rate[j]=Integer.valueOf(rs2.getString(1));
	   		j++;}
			
		rs2.close();
		
	
		stmt.close(); 
		conn.close();
%>
	
	
    <script>
		var names =new Array(94);
		var score =new Array(94);
		<%   
	   		for(int z=0;z <94;z++){   %> 
			names[ <%=z%> ]= " <%=NAME[z]%> ";
			score[ <%=z%> ]= " <%=rate[z]%> ";	  
		<% } %>
		
		var data =new Array(94);
		for(a=0;a<94;a++)
			{
				data[a]=[names[a],Number(score[a])];
			}
       /* var data=[["OMITB*",100],["BETTER THINGS",98],["ATLANTA",97],["R*DOGS",98],["JUSTIFIED",97],["WWDITS*",97],["PEN15",97],["HARLOTS",97],["MCCARTNEY",97],["N.T.",97],["MRS.A",97],["RAMY",96],["D.PEOPLE",96],["SOLAR OPPOSITES",96],["YRTW*",95],["L.VICTOR",95],["TWM*",95],["MR.I",95],["IASIP*",94],["GREAT",94],["MSW*",94],["LEGIT",94],["ACCIDENT",93],["FARGO",93],["WILFRED",83],["LYAWS*",93],["CASUAL",92],["BKS",92],["SSQT*",92],["TRIERS",92],["LEGION",91],["NP*",91],["DAMAGES",91],["TWU*",91],["FUTUREM",91],["BDS",91],["LFA*",91],["ARCHER",90],["SHIELD",90],["ANIM.",90],["CSR*",90],["RESCUEM",89],["STAGED",89],["C.ROCK",88],["D.OUT",90],["DOP",88],["TLT*",88],["ACT",88],["MODOK.",88],["L&B",91],["SOA*",87],["SHRILL",88],["SF*",87],["TMP*",86],["HF*",86],["M M.C.",86],["RICHES",86],["RA*",85],["DASBOOT",85],["C-22",84],["TNYTP*",84],["DAVE",84],["HMAID*",83],["112263",83],["DEVS",82],["M.LAND",82],["F/V",81],["UR*",81],["LEAGUE",81],["THIEF",81],["HILLARY",79],["H-M",81],["D404",80],["STRAIN",79],["P&T",79],["LFE*",79],["TRUST",78],["AHS*",77],["PATH",77],["TABOO",76],["Y:TLM*",76],["CHANCE",75],["TMDAOA*",75],["WOKE",74],["WUTANG",74],["TEACHER",73],["ITD*",69],["FIRST",66],["AWOE",64],["S&D&R&R",61],["TYRANT",60]];*/
        
		var option = {fontSizeFactor: 1, 
                      maxFontSize: 28, 
                      minFontSize: 10, 
                      gridSize:0, 
                      fontWeight:550,  
                      fontFamily: "Gill Sans", 
                      //backgroundColor:'#000', 
                      origin:[0,100],
                      //备注显示框
                      tooltip: {show:true, 
                         backgroundColor: 'black', 
                         formatter: function(item) { 
                             return item[0] + ' get ' + item[1] + '% good'}
                         },
                         list: data,
                         color: '#74c476',
                         imageShape: 'hulu.png'};
        var wc = new Js2WordCloud(document.getElementById('cloud'));
        wc.setOption(option);
    </script>

<!--
<script type="text/javascript">  
	var  width=(window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth)*0.9;
	var  height=(window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight)*0.9;
	var  img_h=50;
	var  img_w=50;
	var  radius=10;
	var svg=d3.select("body")  
			.append("svg")  
			.attr("width",width)  
			.attr("height",height); 

	var nodes=[
			{name:"迪士尼",image:"Dis.jpg",intro:"好莱坞制片厂巨头"},
			{name:"华纳",image:"WN.jpg",intro:"好莱坞六大制片厂之一"},
			{name:"康卡斯特",image:"COMCAST.jpg",intro:"全美最大的有线电视公司"},
			{name:"派拉蒙",image:"para.jpg",intro:"好莱坞老牌制片厂"},
			{name:"HBO",image:"HBO.jpg",intro:"HBO电视网，母公司为华纳"},
			{name:"NBC环球",image:"NBC.jpg",intro:"美国全国广播公司，母公司为康卡斯特"},
			{name:"亚马逊",image:"amazon.jpg",intro:"电商行业巨头"},
			{name:"苹果",image:"apple.jpg",intro:"科技行业巨头"},
			{name:"Netflix",image:"netflix.jpg",intro:"目前世界上订阅用户数最多的、影响力最大的流媒体巨无霸"},
			{name:"HBO MAX",image:"HBO MAX.jpg",intro:"HBO与华纳合作的流媒体平台"},
			{name:"Disney+",image:"Disney+.jpg",intro:"迪士尼旗下流媒体平台，主要业务线为漫威、国家地理等"},
			{name:"hulu",image:"hulu.jpg",intro:"迪士尼旗下流媒体平台，主要业务线为原创剧集"},
			{name:"Prime Video",image:"PV.jpg",intro:"亚马逊旗下流媒体平台，目前世界上订阅人数第二多的流媒体平台"},
			{name:"Peacock",image:"peacock.jpg",intro:"NBC环球旗下流媒体平台"},
			{name:"Paramount+",image:"P+.jpg",intro:"派拉蒙旗下流媒体平台"},
			{name:"Apple TV+",image:"apple+.jpg",intro:"苹果公司流媒体平台"}];
	
	var edges=[
		   {source:0,target:1,relation:"竞争对手"},{source:0,target:3,relation:"竞争对手"},
		   {source:0,target:1,relation:"竞争对手"},
		   {source:0,target:10,relation:"母公司"},{source:0,target:11,relation:"母公司"},
		   {source:8,target:9,relation:"竞争对手"},{source:6,target:12,relation:"母公司"},
		   {source:10,target:11,relation:"不同业务"}, {source:1,target:3,relation:"竞争对手"}, 
		   {source:4,target:5,relation:"竞争对手"}, {source:8,target:15,relation:"赶超目标"},
		   {source:8,target:10,relation:"赶超目标"},{source:8,target:11,relation:"赶超目标"},
		   {source:8,target:13,relation:"赶超目标"},{source:8,target:14,relation:"赶超目标"},
		   {source:13,target:15,relation:"流媒体新秀"},{source:11,target:12,relation:"竞争"},
		   {source:9,target:13,relation:"竞争"},{source:9,target:14,relation:"竞争"},
		   {source:1,target:4,relation:"母公司"},{source:1,target:9,relation:"母公司"},
		   {source:4,target:9,relation:"母公司"}, {source:2,target:5,relation:"母公司"}, 
		   {source:2,target:13,relation:"母公司"},{source:5,target:13,relation:"母公司"},
		   {source:3,target:14,relation:"母公司"}, {source:8,target:12,relation:"赶超目标"},
		   {source:6,target:7,relation:"科技行业竞争"},{source:7,target:15,relation:"母公司"}];
		   
	var force=d3.layout.force()
			.nodes(nodes)
			.links(edges)
			.size([width,height])
			.linkDistance(150)
			.charge(-1200)
			.start();	
	
	//提示框部分
	var tooltip=d3.selectAll("body")  
				.append("div")  
				.attr("class","tooltip")  
				.style("opacity",0); 

   //箭头绘制	
	var defs = svg.append("defs");
	var radius=10;
	var arrowMarker = defs.append("marker")
							.attr("id","arrow")
							.attr("markerUnits","strokeWidth")
							.attr("markerWidth","4")
							.attr("markerHeight","4")
							.attr("viewBox","0 0 4 4")
							.attr("refX",20+radius/8-2)   //实际是radius/strokeWidth
							.attr("refY",2)
							.attr("orient","auto");

	var arrow_path = "M0,1 L4,2 L0,3 L0,0";

	arrowMarker.append("path")
				.attr("d",arrow_path); 					
	var color=d3.scale.category20();
	var path = svg.selectAll("path")
							  .data(edges)
							  .enter()
							  .append("path")
							  .attr("id", function(d,i) {
								   return "edgepath" +i;
							  })
							  .attr("class","edges")
							  .attr("marker-end","url(#arrow)");		
	var pathtext = svg.selectAll('.pathText')
			  .data(edges)
			  .enter()
			  .append("text")
			  .attr("class","pathText")
			  .append('textPath')
			  .attr("text-anchor", "middle")//居中
			  .attr("startOffset","50%")
			  .attr('xlink:href', function(d,i) { return "#edgepath" + i; })
			  .text(function(d) { return d.relation; });						  
	var  img_h=50;
	var  img_w=50;
	var  radius=23;								
	var  circles=svg.selectAll("forceCircle")
			   .data(nodes)
			   .enter()
			   .append("circle")
			   .attr("class","forceCircle")
			   .attr("r",radius)
			   .style("stroke","DarkGray")
			   .style("stroke-width","1.0px")
			   .attr("fill", function(d, i){
								//创建圆形图片
								var defs = svg.append("defs").attr("id", "imgdefs");
								var catpattern = defs.append("pattern")
													 .attr("id", "catpattern" + i)
													 .attr("height", 1)
													 .attr("width", 1);
								catpattern.append("image")
										.attr("x", - (img_w / 2 - radius))
										.attr("y", - (img_h / 2 - radius))
										.attr("width", img_w)
										.attr("height", img_h)
										.attr("xlink:href","img/"+d.image);
								return "url(#catpattern" + i + ")";
				})
	
				.on("mouseover",function(d,i){    //加入提示框
					tooltip.html("简介："+d.intro)
						   .style("left",(d3.event.pageX)+"px")  
						   .style("top",(d3.event.pageY+30)+"px")  
						   .style("opacity",1);  
				})
	
				.on("mousemove",function(d){            
					  tooltip.style("left",(d3.event.pageX)+"px")  
							 .style("top",(d3.event.pageY+30)+"px"); }) 
	
			   .on("mouseout",function(d){  
					tooltip.style("opacity",0); })
	
			   .call(force.drag); 
	
	var texts=svg.selectAll(".forceText")
			 .data(nodes)
			 .enter()
			 .append("text")
			 .attr("class","forceText")
			 .attr("x",function(d){return d.x;})
			 .attr("y",function(d){return d.y;})
			 .style("stroke", "#000")
			 .attr("dx","-1.5em")
			 .attr("dy","3.7em")
			 .text(function(d){return d.name;});
				 
	force.on("tick",function(){
		  path.attr("d", function(d) {
				var dx = d.target.x - d.source.x;//增量
				var	dy = d.target.y - d.source.y;
				return "M" + d.source.x + ","+ d.source.y + "L" + d.target.x + "," + d.target.y;
			  });
		  circles.attr("cx",function(d){return d.x;});
		  circles.attr("cy",function(d){return d.y;});
		  texts.attr("x",function(d){return d.x;});
		  texts.attr("y",function(d){return d.y;});
	});
</script>
<br><br><br><br><br><br>




<script type="text/javascript">

	var w=window.innerWidth|| document.documentElement.clientWidth|| document.body.clientWidth;
	var h=window.innerHeight|| document.documentElement.clientHeight|| document.body.clientHeight;
		var width = w*0.85;
		var height =h*0.94;
	
	 
	var color = d3.scale.category20b();//20种颜色
	 
	//(1)填充树
	var treemap = d3.layout.treemap()//使用递归的空间分割来显示节点的树。
		.size([width-100, height-40])//指定x和y的布局大小。
		.padding(0)//指定一个父及其子之间的填充。
		.value(function(d) { //获取或设置树形细胞的大小。
		return d.size/2; 
		});
		
	
	//(2)设置每个树细胞用div存放
	var div = d3.select("body").append("div")
		.style("position", "relative")
		.style("align-items","center")
		.style("justify-content","center")
		.style("display","flex")
		.style("margin-left","130px")
		.style("width", width + "px")
		.style("height", height + "px");
		
	
	//(3)设置每个树细胞各个属性
	d3.json("paddingTree.json", 
		function(error, root) {
	  
		div.selectAll(".node")
		  .data(treemap.nodes(root))//计算树形布局和返回节点的数组。
		  .enter().append("div")
		  .attr("class", "node")
		  .style("left", function(d) { return d.x + "px"; })
		  .style("top", function(d) { return d.y + "px"; })
		  .style("width", function(d) { return Math.max(0, d.dx -1 ) + "px"; })
		  .style("height", function(d) { return Math.max(0, d.dy-1 ) + "px"; })
		  
		  .style("background", function(d) { 
			  return d.children ? color(d.name) : null; 
		  })
	
		  .text(function(d) { //同理，孩子设置文字，爸爸没有
			  return d.children ? null : d.name; 
		  });
	});
	</script>

	<table style="margin: 0 auto;font-size: 12px;">
	  <tr>
	   <td bgcolor="#CEDB9C" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;纪录片&nbsp;&nbsp;</td> 
	 	
		<td bgcolor="#b5cf6b" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;附加频道&nbsp;&nbsp;</td>

	 <td bgcolor="#7ab10e" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;悬疑惊悚&nbsp;&nbsp;</td>
	   
	   
	   <td bgcolor="#8ca252" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;剧情&nbsp;&nbsp;</td>

	  <td bgcolor="#637939" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;社会&nbsp;&nbsp;</td>

		<td bgcolor="#118129" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;喜剧&nbsp;&nbsp;</td>

	   
		<td bgcolor="#25591b" height="20" width="40">&nbsp;</td>
	   <td>&nbsp;&nbsp;复古&nbsp;&nbsp;</td>
	 
	  </tr>
	 </table>
	 <br><br><br><br><br><br><br><br><br><br><br>-->

</body>
</html>
