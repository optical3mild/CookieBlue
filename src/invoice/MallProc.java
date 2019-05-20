package invoice;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import function.CustomerFunction;

@WebServlet("/view/MallProc")
public class MallProc extends HttpServlet {
	private static final Logger LOG = LoggerFactory.getLogger(MallProc.class);
	private static final long serialVersionUID = 1L;
       
    public MallProc() {
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doAction(request, response);
	}
	
	protected void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//공통 설정
		request.setCharacterEncoding("UTF-8");
		RequestDispatcher rd;
		HttpSession session = request.getSession();
		String action = request.getParameter("action");
		CustomerFunction cf = new CustomerFunction();
		String message = new String();
		
		String cookieId = new String();
		boolean cookieOut = true;
		
		String userId = new String();
		String userName = new String();
		int userType = 0;
		
		Cookie[] cookies = request.getCookies();
		for (Cookie cookie: cookies) {
			if (cookie.getName().equals("mall")) {
				cookieId = cookie.getValue();
				cookieOut = false;
			}
			LOG.debug("{}, {}", cookie.getName(), cookie.getValue());
		}
		LOG.trace("cookieId : " + cookieId);
		
		if(cookieOut) {
			LOG.trace("쿠키 삭제되서 로그인 페이지로 이동");
			action ="";
			response.sendRedirect("../index.jsp");
		} else {
			LOG.trace("cookieId : " + cookieId);
			request.setAttribute("cookieId", cookieId);
			userId = (String)session.getAttribute(cookieId+"userId");
			userName = (String)session.getAttribute(cookieId+"userName");
			userType = (Integer)session.getAttribute(cookieId+"userType");
		}
		//DTO,DAO 관련 변수
		InvoiceDAO iDao = new InvoiceDAO();
		OrderDAO oDao = new OrderDAO();
		InvoiceDTO iDto = new InvoiceDTO();
		List<InvoiceDTO> iDtoLists = new ArrayList<InvoiceDTO>();
    	OrderDTO oDto = new OrderDTO();
    	List<OrderDTO> oDtoLists = new ArrayList<OrderDTO>();
		
    	//일반 변수
    	String iCode = new String(); //송장번호를 받는 변수
    	String date = new String();
    	String month = new String();
    	int monthTotalSales = 0; //1. 이번달 매출액을 저장
    	int lastYearTotalSales = 0; //2. 작년도 매출액을 저장
    	int thisYearTotalSales = 0; //3. 이번년도 매출액을 저장
    	int monthListCount = 0; //4. 이번달 처리 송장 건수를 저장
    	int monthTotalPrice = 0; //월별 매출액을 저장
    	
    	List<Integer> lastTotalSalesList = new ArrayList<Integer>();
    	List<Integer> thisTotalSalesList = new ArrayList<Integer>();
    	
    	switch(action) {
    	case "intoMain" :
    		LOG.trace("[쇼핑몰 Proc] 메인페이지 입장");
    		//1. 이번달 지불 액수 
    		iDtoLists = iDao.mallSalesMonth(userId.charAt(0),cf.curMonth()); //이번달 처리가 완료된 송장 리스트를 불러온다.
    		monthListCount = iDtoLists.size();
    		for(InvoiceDTO invoice : iDtoLists) {
    			oDtoLists = oDao.selectAll(invoice.getiCode());
    			for(OrderDTO order : oDtoLists) {
    				monthTotalSales += order.getoQuantity()*order.getpPrice()*1.1;
    			}
    			monthTotalSales += 10000;
    		}
    		LOG.trace("[쇼핑몰 Proc] 이번달 매출액 계산 완료");
    		
			//3.올해 월별 지불 액수
			for(int m=1;m<13;m++) {
				monthTotalPrice = 0;
				if(m>Integer.parseInt(cf.curMonth().substring(5))-1) {
					LOG.trace("현재 달 보다 숫자가 큼");
					break;
				}
				iDtoLists = iDao.mallSalesYearMonth(cf.curYear(),userId.charAt(0),m);
				LOG.trace("[쇼핑몰 Proc]"+m+"월 송장 수 : "+iDtoLists.size()+"");
				for(InvoiceDTO invoice : iDtoLists) {
					oDtoLists = oDao.selectAll(invoice.getiCode());
	    			for(OrderDTO order : oDtoLists) {
	    				monthTotalPrice += order.getoQuantity()*order.getpPrice()*1.1;
	    			}
	    			monthTotalPrice += 10000;
	    		}
				thisTotalSalesList.add(monthTotalPrice); //월별 총액을 리스트로 저장
				thisYearTotalSales += monthTotalPrice; //올해 총액을 int로 저장
			}
			//3.작년 월별 지불 액수
			for(int m=1;m<13;m++) {
				monthTotalPrice = 0;
				iDtoLists = iDao.mallSalesYearMonth(cf.lastYear(cf.curYear()),userId.charAt(0),m);
				LOG.trace("[쇼핑몰 Proc]"+m+"월 송장 수 : "+iDtoLists.size()+"");
				for(InvoiceDTO invoice : iDtoLists) {
					oDtoLists = oDao.selectAll(invoice.getiCode());
	    			for(OrderDTO order : oDtoLists) {
	    				monthTotalPrice += order.getoQuantity()*order.getpPrice()*1.1;
	    			}
	    			monthTotalPrice += 10000;
	    		}
				lastTotalSalesList.add(monthTotalPrice); //월별 총액을 리스트로 저장
				lastYearTotalSales += monthTotalPrice; //올해 총액을 int로 저장
			}
    		
    		request.setAttribute("monthTotalSales", monthTotalSales); //1. 이번달 지불액
    		request.setAttribute("lastYearTotalSales", lastYearTotalSales); //2. 작년 총 지불액
    		request.setAttribute("thisYearTotalSales", thisYearTotalSales);//3. 이번년 총 지불액 
    		request.setAttribute("monthListCount", monthListCount); //4. 이번달 처리 송장 건수
    		
    		request.setAttribute("thisTotalSalesList", thisTotalSalesList); //5. 올해 월별 총 지불액
    		request.setAttribute("lastTotalSalesList", lastTotalSalesList); //5. 작년 월별 총 지불액
    		rd = request.getRequestDispatcher("mall/mallMain.jsp");
			rd.forward(request, response);
			break;
		
		//1. [일별 배송목록] 날짜에서 일에 해당하는 부분을 가져와 해당 하루 리스트를 DTO로 받는다.
		case "mallInvoiceListDay":
			LOG.trace("[쇼핑몰 Proc] 일별 배송 목록");
			iDtoLists = iDao.mallSearchAllDay(userId.charAt(0),cf.curDate()); //쇼핑몰의 코드를 통해 오늘 날짜의 송장 목록을 가져온다.
			request.setAttribute("invoiceLists", iDtoLists);
			rd = request.getRequestDispatcher("mall/invoiceDayList.jsp"); //쇼핑몰 일별 리스트 화면으로 송장 리스트를 던져준다.
			rd.forward(request, response);
			break;
		
		//2. [월별 배송목록] 날짜에서 월에 해당하는 부분을 가져와 해당 월의 리스트를 DTO로 받는다.
		case "mallInvoiceListMonth":
			LOG.trace("[쇼핑몰 Proc] 월별 배송 목록");
			iDtoLists = iDao.mallSearchAllMonth(userId.charAt(0),cf.curMonth());
			request.setAttribute("invoiceLists", iDtoLists);
			rd = request.getRequestDispatcher("mall/invoiceMonthList.jsp"); //쇼핑몰 월별 리스트 화면으로 송장 리스트를 던져준다.
			rd.forward(request, response);
			break;
			
		
		//3. [기능 : 날짜 검색] 날짜를 선택해서 해당항는 부분의 하루 리스트를 DTO로 받는다.
		case "mallSearchDayList":
			if (request.getParameter("date").equals("")) {
				message = "날짜를 선택해 주세요.";
				request.setAttribute("message", message);
				request.setAttribute("msgState", true);
				rd = request.getRequestDispatcher("MallProc?action=mallInvoiceListDay");
				rd.forward(request, response);
				break;
			}
			date = request.getParameter("date"); //페이지로부터 선택한 날짜를 가져온다.
			LOG.trace("[쇼핑몰 Proc] 선택한 날짜 : "+date);
			iDtoLists = iDao.mallSearchAllDay(userId.charAt(0), date); //쇼핑몰의 코드와 날짜를 통해 이번 월의 송장목록을 가져온다.
			request.setAttribute("selectDate", date); //날짜를 표시하기위해 다시 던져준다.
			request.setAttribute("invoiceLists", iDtoLists);
			rd = request.getRequestDispatcher("mall/invoiceDayList.jsp"); //쇼핑몰의 하루 리스트 화면으로 송장 리스트를 던져준다.
			rd.forward(request, response);
			break;
			
		case "mallSearchMonthList":
			LOG.trace("[쇼핑몰 Proc] 월별 배송 목록 검색");
			if (request.getParameter("month").equals("")) {
				message = "날짜를 선택해 주세요.";
				request.setAttribute("message", message);
				request.setAttribute("msgState", true);
				rd = request.getRequestDispatcher("MallProc?action=mallInvoiceListMonth");
				rd.forward(request, response);
				break;
			}
			month = request.getParameter("month"); //페이지로부터 선택한 날짜를 가져온다.
			LOG.trace("[쇼핑몰 Proc] 선택한 달 : "+ month);
			iDtoLists = iDao.mallSearchAllMonth(userId.charAt(0), month); //쇼핑몰의 코드와 날짜를 통해 이번 월의 송장목록을 가져온다.
			request.setAttribute("selectDate", month); //날짜를 표시하기위해 다시 던져준다.
			request.setAttribute("invoiceLists", iDtoLists);
			rd = request.getRequestDispatcher("mall/invoiceMonthList.jsp"); //쇼핑몰의 하루 리스트 화면으로 송장 리스트를 던져준다.
			rd.forward(request, response);
			break;
			
		//4. [송장 상세 보기] 송장 번호에 해당하는 제품 목록을 가져온다.
		case "detailList": 
			//하나의 송장 정보와 해당 송장정보의 모든 제품 목록을 가져온다.
			iCode = request.getParameter("iCode");
			LOG.trace("[쇼핑몰 Proc] 송장 번호 : "+iCode);
			
			iDto = iDao.selectOneCode(iCode);
			oDtoLists = oDao.selectAll(iCode);
			
			int totalProductPrice = 0;
			
			for(OrderDTO order : oDtoLists) totalProductPrice += order.getoTotalPrice();
			
			request.setAttribute("invoiceTotalPrice", totalProductPrice);
			request.setAttribute("invoice", iDto);
			request.setAttribute("orderLists", oDtoLists);
			rd = request.getRequestDispatcher("mall/invoiceDetailList.jsp");
			rd.forward(request, response);
			
			break;
			
		case "readCSV": //송장CSV파일 받기 case	
			int count = 0;
	        try {
	        	LOG.trace("[쇼핑몰 Proc] 송장 처리 시작");
	            // csv 데이터 파일
	        	if (request.getParameter("fileName1").equals("")) {
					message = "파일을 선택해 주세요.";
					request.setAttribute("message", message);
					request.setAttribute("msgState", true);
					rd = request.getRequestDispatcher("MallProc?action=mallInvoiceListDay");
					rd.forward(request, response);
					break;
				}
	        	LOG.trace("파일 이름 : " + request.getParameter("fileName1") );
	        	String csvFile ="C://temp//"+ request.getParameter("fileName1") ;
	            File csv = new File(csvFile);
	            BufferedReader br = new BufferedReader(new FileReader(csv));
	            String line = "";
	            String[] customer = new String[5]; //이름,전화번호,주소를 저장할 공간
	 
	            while ((line = br.readLine()) != null) {
	                // -1 옵션은 마지막 "," 이후 빈 공백도 읽기 위한 옵션
	                String[] token = line.split(",", -1);
//	                System.out.println(token.length); //길이는 값이 있던 없던 똑같다.
	                //이름이 비어있을 경우, 이전 고객 정보로 저장
	                if(!token[0].equals("")) {
	                	LOG.trace("고객정보 있음");
	                	//같을 경우, 새로운 송장 정보를 생성
	                	customer[1] = token[0]; //이름
	                	customer[2] = token[1]; //전화번호
	                	customer[3] = token[2]; //주소
	                	customer[4] = cf.iAreaCode(token[2]); //지역코드
	                	customer[0] = cf.iCodeProc(userId,customer[4]); //송장번호
	                	//송장번호 이름 전화번호 주소 지역코드를 DTO에 넣는다. 
	                	iDto = new InvoiceDTO(customer); 
	                	LOG.trace(iDto.toString());
	                	//송장번호 이름 전화번호 주소 지역코드를 DB에 넣는다.
	                	//날짜와 배송 상태는 DAO에서 처리한다.
	                	iDao.insertInvoice(iDto);
	                	count++;              	
	                }   
	                
	                //제품번호, 송장번호, 제품수량을 DTO에 넣는다.
	                try {
						oDto = new OrderDTO(token[3],customer[0],Integer.parseInt(token[4]));
					} catch (NumberFormatException e) {
						e.printStackTrace();
					}
	                LOG.trace(oDto.toString());
	                //제품번호, 송장번호, 제품수량을 DB에 넣는다.
	                //제품 인덱스는 DB에서 처리한다.
	                oDao.insertOrder(oDto);      
	            }
	            br.close();
	 
	        } 
	        catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } 
	        catch (IOException e) {
	            e.printStackTrace();
	        }
	        message = "총 " +count+"건의 송장 처리를 신청하셨습니다.";
			request.setAttribute("message", message);
			request.setAttribute("msgState", true);
	        rd = request.getRequestDispatcher("MallProc?action=mallInvoiceListDay");
			rd.forward(request, response);
			break;		
		default:
			break;
		}
	}

}
