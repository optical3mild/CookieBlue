<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <link rel="shortcut icon" href="../img/favicon1.ico" type="image/x-icon" >
  <link rel="icon" href="../img/favicon1.ico" type="image/x-icon" >
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>발주 신청내역</title>

  <!-- Custom fonts for this template-->
  <link href="../vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">

  <!-- Custom styles for this template-->
  <link href="../css/sb-admin-2.min.css" rel="stylesheet">

  <!-- Custom styles for this page -->
  <link href="../vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">
  
  <link href="../css/bluecompany.css" rel="stylesheet">
</head>
<body id="page-top">
  <!-- Page Wrapper -->
  <div id="wrapper">
    <c:set value="admin" var="navRecall"/>
    <%@ include file="../common/_navigator.jspf" %>
    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">
      <!-- Main Content -->
      <div id="content">
        <%@ include file="../common/_top.jspf" %>
        <!-- Begin Page Content -->
        <div class="container-fluid">
          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">
            <h1 class="h3 mb-2 text-gray-600 boldfont">발주 신청내역</h1>
          </div>
          
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3 d-sm-flex align-items-center justify-content-between">
              <h6 class="m-0 font-weight-bold text-primary d-sm-inline-block" style="line-height:2">${selectDate}</h6>
              <div class="dropdown no-arrow">
                <a href="AdminProc?action=permitSupply" class="d-none d-sm-inline-block btn btn-sm btn-primary shadow-sm">
                  <i class="fas fa-file-signature"></i>&nbsp;&nbsp;승인
                </a>
                <button class="btn btn-primary btn-sm shadow-sm" role="button" id="excuteWriteCSV">
                  <i class="fas fa-download"></i>&nbsp;&nbsp;CSV파일저장
                </button>
              </div>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                   <colgroup>
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:33%">
					<col style="width:15%">
					<col style="width:10%">
					<col style="width:10%">
					<col style="width:12%">
				  </colgroup>
                  <thead>
                    <tr>
                      <th style="text-align: center;">발주코드</th>
                      <th style="text-align: center;">상품코드</th>
                      <th style="text-align: center;">상품이름</th>
                      <th style="text-align: center;">날짜</th>
                      <th style="text-align: center;">발주량</th>
                      <th style="text-align: center;">단가</th>
                      <th style="text-align: center;">총액</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th colspan="5"></th>
                      <th style="text-align: center;">총액</th>
                      <th style="text-align: right;"><fmt:formatNumber value="${requestScope.supplyTotalSales}" pattern="#,##0"/>원</th>
                    </tr>
                  </tfoot>
                  <tbody>
                    <c:set var="supplyList" value ="${requestScope.supplyList}"/>
					<c:forEach var="supply" items="${supplyList}">
	                 <tr>
                      <td style="text-align: center;">${supply.sCode}</td>
                      <td style="text-align: center;">${supply.pCode}</td>
                      <td style="text-align: left;">${supply.pName}</td>
                      <td style="text-align: center;">${supply.sDate}</td>
                      <td style="text-align: right;">${supply.sQuantity}</td>
                      <td style="text-align: right;"><fmt:formatNumber value="${supply.pPrice}" pattern="#,##0"/>원</td>
                      <td style="text-align: right;"><fmt:formatNumber value="${supply.sTotalPrice}" pattern="#,##0"/>원</td>
                   	</tr>
                 	</c:forEach>
                  </tbody>
                </table>
             </div>
           </div>
         </div>
          <!-- 위까지 그래프  -->
        </div>
        <!-- /.container-fluid -->
      </div>
      <!-- End of Main Content -->
      <%@ include file="../common/_bottom.jspf" %>
    </div>
    <!-- End of Content Wrapper -->
  </div>
  <!-- End of Page Wrapper -->

  <!-- Bootstrap core JavaScript-->
  <script src="../vendor/jquery/jquery.min.js"></script>
  <script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

  <!-- Core plugin JavaScript-->
  <script src="../vendor/jquery-easing/jquery.easing.min.js"></script>

  <!-- Custom scripts for all pages-->
  <script src="../js/sb-admin-2.min.js"></script>

  <!-- Page level plugins -->
  <script src="../vendor/datatables/jquery.dataTables.min.js"></script>
  <script src="../vendor/datatables/dataTables.bootstrap4.min.js"></script>

  <!-- dataTable Export Lib -->
  <script src="https://cdn.datatables.net/buttons/1.5.2/js/dataTables.buttons.min.js"></script>
  <script src="https://cdn.datatables.net/buttons/1.5.2/js/buttons.html5.min.js"></script>
  
  <!-- Page level custom script for dataTable -->
  <script src="../js/bluecompany.js"></script>
</body>
</html>

<%@ include file="../common/_messageModal.jspf" %>