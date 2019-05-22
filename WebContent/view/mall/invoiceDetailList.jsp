<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <link rel="shortcut icon" href="../img/favicon1.ico" type="image/x-icon" >
  <link rel="icon" href="../img/favicon1.ico" type="image/x-icon" >
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <meta name="description" content="">
  <meta name="author" content="">

  <title>쇼핑몰 송장 상세페이지</title>

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
    <c:set value="mall" var="navRecall"/>
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
            <h1 class="h3 mb-2 text-gray-600 boldfont">상세페이지</h1>
          </div>
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3 d-sm-flex align-items-center justify-content-between">
              <div class="d-inline-block">
              <table>
                <tr>
                  <c:set var="invoice" value="${requestScope.invoice}"/>
                  <td style="text-align: center;"><h6 class="m-0 font-weight-bold text-primary">송장번호: ${invoice.iCode} &nbsp;&nbsp;</h6></td>
                  <td style="text-align: center;">&nbsp;&nbsp;성명 : ${invoice.iName}&nbsp;&nbsp;</td>
                  <td style="text-align: center;">&nbsp;&nbsp;주소 : ${invoice.iAddress}&nbsp;&nbsp;</td>
                  <td style="text-align: center;">&nbsp;&nbsp;연락처 : ${invoice.iTel}&nbsp;&nbsp;</td>
                  <td style="text-align: center;">&nbsp;&nbsp;날짜 : ${invoice.iDate}&nbsp;&nbsp;</td>
                </tr>
              </table>
              </div>
              <div class="d-inline-block">
                <button class="btn btn-primary btn-sm shadow-sm" role="button" id="excuteWriteCSV">
                  <i class="fas fa-download"></i>&nbsp;&nbsp;CSV파일저장
                </button>
              </div>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                <colgroup>
					<col style="width:15%">
					<col style="width:40%">
					<col style="width:15%">
					<col style="width:15%">
					<col style="width:15%">
				  </colgroup>
                  <thead>
                    <tr>
                      <th style="text-align: center;">주문번호</th>
                      <th style="text-align: center;">상품명</th>
                      <th style="text-align: center;">개수</th>
                      <th style="text-align: center;">단가</th>
                      <th style="text-align: center;">합계</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:set var="orderLists" value="${requestScope.orderLists}"/>
					<c:forEach var="order" items="${orderLists}">
                    <tr>
                      <td style="text-align: center;">${order.oNum}</td>
                      <td style="text-align: left;">${order.oProductName}</td>
                      <td style="text-align: right;">${order.oQuantity}</td>
                      <td style="text-align: right;"><fmt:formatNumber value="${order.pPrice}" pattern="#,##0"/>원</td>
                      <td style="text-align: right;"><fmt:formatNumber value="${order.oTotalPrice}" pattern="#,##0"/>원</td>
                    </tr>
                    </c:forEach>
                  </tbody>
                  <tfoot>
                    <tr>
                      <th></th>
                      <th></th>
                      <th></th>
                      <th style="text-align: center;">총액</th>
                      <th style="text-align: right;"><fmt:formatNumber value="${requestScope.invoiceTotalPrice}" pattern="#,##0"/>원</th>
                    </tr>
                  </tfoot>
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
  
  <script src="../js/bluecompany.js"></script>
</body>
</html>

<%@ include file="../common/_messageModal.jspf" %>