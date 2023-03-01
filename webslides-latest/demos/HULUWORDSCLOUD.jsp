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

		body{
			background-color: transparent;
		}			
	</style>
</head>
<body>
	<!--
	<a href="https://cuc.yingshinet.com/CH12/renminWC.htm">
	
		<img style="width: 150px;height: 75px;position: absolute;left: 260px;top: 20px;" src="Hulusign.png"></a>
	<div id="headline" style="text-align: center; margin:15px auto;width: 500px;height: 40px;font-size: 27px;font-weight: 700;">烂番茄网站94部HULU评分最高剧集</div>
	<p style="" align="center">19数科 姜力菲</p>
	
	<br>-->
	
    <div id="cloud" style="margin:0 auto; width:1100px;height:370px;background-color: transparent;"></div><br><br>
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
                      backgroundColor:"transparent", 
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

</body>
</html>
