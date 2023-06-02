<%@ page language="java" import="java.util.*"  contentType="text/html;charset=UTF-8"%> 
<%@ page import="com.chengxusheji.po.PostInfo" %>
<%@ page import="com.chengxusheji.po.UserInfo" %>
<%@ page import="com.chengxusheji.po.Reply" %>
<%@ taglib prefix="sf" uri="http://www.springframework.org/tags/form" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
    //获取所有的userObj信息
    List<UserInfo> userInfoList = (List<UserInfo>)request.getAttribute("userInfoList");
    PostInfo postInfo = (PostInfo)request.getAttribute("postInfo");
    
    ArrayList<Reply> replyList = (ArrayList<Reply>) request.getAttribute("replyList");
    
    int zanState = Integer.parseInt(request.getAttribute("zanState").toString());
    
    int zanNum = Integer.parseInt(request.getAttribute("zanNum").toString());

%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1 , user-scalable=no">
  <TITLE>查看文章详情</TITLE>
  <link href="<%=basePath %>plugins/bootstrap.css" rel="stylesheet">
  <link href="<%=basePath %>plugins/bootstrap-dashen.css" rel="stylesheet">
  <link href="<%=basePath %>plugins/font-awesome.css" rel="stylesheet">
  <link href="<%=basePath %>plugins/animate.css" rel="stylesheet"> 
</head>
<body style="margin-top:70px;"> 
<jsp:include page="../header.jsp"></jsp:include>
<div class="container">
	<ul class="breadcrumb">
  		<li><a href="<%=basePath %>index.jsp">首页</a></li>
  		<li><a href="<%=basePath %>PostInfo/frontlist">文章信息</a></li>
  		<li class="active">详情查看</li>
	</ul>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">文章id:</div>
		<div class="col-md-10 col-xs-6"><%=postInfo.getPostInfoId()%></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">文章标题:</div>
		<div class="col-md-10 col-xs-6"><%=postInfo.getTitle()%></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">文章图片:</div>
		<div class="col-md-10 col-xs-6"><img class="img-responsive" src="<%=basePath %><%=postInfo.getPostPhoto() %>"  border="0px"/></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">文章内容:</div>
		<div class="col-md-10 col-xs-6"><%=postInfo.getContent()%></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">浏览量:</div>
		<div class="col-md-10 col-xs-6"><%=postInfo.getHitNum()%></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">发布人:</div>
		<div class="col-md-10 col-xs-6"><a href="<%=basePath %>UserInfo/<%=postInfo.getUserObj().getUser_name() %>/frontshow" target="_blank"><%=postInfo.getUserObj().getName() %></a></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">发布时间:</div>
		<div class="col-md-10 col-xs-6"><%=postInfo.getAddTime()%></div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold">回复内容:</div>
		<div class="col-md-10 col-xs-6">
			<textarea id="content" style="width:100%" rows=8></textarea>
		</div>
	</div>
	
	<div class="row bottom15">
		<div class="col-md-2 col-xs-4"></div>
		<div class="col-md-6 col-xs-6">
			<button onclick="userReply();" class="btn btn-primary">发布回复</button>
			<button onclick="userZan();" class="btn btn-primary"><%=zanState==1?"取消点赞":"我要点赞" %></button>
			<button onclick="history.back();" class="btn btn-info">返回</button>
			&nbsp;&nbsp;共&nbsp;<a href="<%=basePath %>ZanInfo/frontlist?postObj.postInfoId=<%=postInfo.getPostInfoId() %>" style="color:red;text-decoration: underline;"><%=zanNum %>人</a>&nbsp;点赞
		</div>
	</div>
	<div class="row bottom15"> 
		<div class="col-md-2 col-xs-4 text-right bold"></div>
		<div class="col-md-8 col-xs-7">
			<% for(Reply reply: replyList) { %>
			<div class="row" style="margin-top: 20px;">
				<div class="col-md-2 col-xs-3">
					<div class="row text-center"><img src="<%=basePath %><%=reply.getUserObj().getUserPhoto() %>" style="border: none;width:60px;height:60px;border-radius: 50%;" /></div>
					<div class="row text-center" style="margin: 5px 0px;"><%=reply.getUserObj().getUser_name() %></div>
				</div>
				<div class="col-md-7 col-xs-5"><%=reply.getContent() %></div>
				<div class="col-md-3 col-xs-4" ><%=reply.getReplyTime() %></div>
			</div>
		
			<% } %> 
		</div>
	</div>
</div> 
<jsp:include page="../footer.jsp"></jsp:include>
<script src="<%=basePath %>plugins/jquery.min.js"></script>
<script src="<%=basePath %>plugins/bootstrap.js"></script>
<script src="<%=basePath %>plugins/wow.min.js"></script>
<script>
var basePath = "<%=basePath%>";
 
function userReply() {
	var content = $("#content").val();
	if(content == "") {
		alert("请输入回复内容");
		return;
	}

	$.ajax({
		url : basePath + "Reply/userAdd",
		type : "post",
		dataType: "json",
		data: {
			"reply.postInfoObj.postInfoId": <%=postInfo.getPostInfoId() %>,
			"reply.content": content
		},
		success : function (data, response, status) {
			//var obj = jQuery.parseJSON(data);
			if(data.success){
				alert("回复成功~");
				location.reload();
			}else{
				alert(data.message);
			}
		}
	});
}


function userZan() {
	$.ajax({
		url : basePath + "ZanInfo/userZan",
		type : "post",
		dataType: "json",
		data: {
			"zanInfo.postObj.postInfoId": <%=postInfo.getPostInfoId() %>,
		},
		success : function (data, response, status) {
			//var obj = jQuery.parseJSON(data);
			if(data.success){
				alert("操作成功~");
				location.reload();
			}else{
				alert(data.message);
			}
		}
	});
}





$(function(){
        /*小屏幕导航点击关闭菜单*/
        $('.navbar-collapse a').click(function(){
            $('.navbar-collapse').collapse('hide');
        });
        new WOW().init();
 })
 </script> 
</body>
</html>

