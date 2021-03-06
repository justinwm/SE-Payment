<?php
import("@.Util.Goods.SourcePlace");
import("@.Util.Goods.GoodsHelper");
import("@.Util.Goods.TimeFormatter");
import("@.Util.User.BuyerHelper");
import("@.Util.CommonValue");
import('@.Org.Util.Page');

class PurchaseAction extends Action {

	public function index(){
		$this->display();
	}

	public function login(){
		$this->display("index");
	}

	public function search(){
		$goods_type = $this->_get('goods-type');
		if (!$goods_type) {
			$goods_type = $this->_get('type');
		}
		$keywords = $this->_get('keywords');
		//set on new search history
		if($userId = $this->_session('uid')) {
			$searchHistory = D('SearchHistory');
			$data = array(
				'search_key' => $keywords,
				'user_id' => $userId,
				'date_time' => time(),
			);
			if ($searchHistory->create($data)){
				$id = $searchHistory->add();
			}
		}
		//to set the correct goods type
		if($goods_type == 'general-goods') {
			$goods = D('GeneralGoods');
		}
		else if($goods_type == 'airplane-ticket') {
			$goods = D('AirplaneTicket');
		}
		else if($goods_type == 'hotel-room') {
			$goods = D('HotelRoom');
		}
		// paging
		// get total count of goods to be paged
		$count = $goods->getGoodsCountWithPurchaseAction($this);
		// new a Page class, with total number of goods and goods per page as parameters
		$Page = new Page($count, CommonValue::getNumberPerPage());
		//get goods from database
		$searchResult = $goods->getGoodsWithPurchaseActionAndPage($this, $Page);
		//format time to readable format
		//date_time field in hotel room
		if($goods->getType() == HotelRoomModel::getType()) {
			for($i = 0; $i < count($searchResult);$i++) {
				$searchResult[$i][date_time] = TimeFormatter::formatTime($searchResult[$i][date_time]);
			}
		}
		//departure_date_time field and arrival_date_time field in airplane ticket
		else if($goods->getType() == AirplaneTicketModel::getType()) {
			for($i = 0; $i < count($searchResult);$i++) {
				$searchResult[$i][departure_date_time] = TimeFormatter::formatTime($searchResult[$i][departure_date_time]);
				$searchResult[$i][arrival_date_time] = TimeFormatter::formatTime($searchResult[$i][arrival_date_time]);
			}
		}
		//add prefix image_uri generate vip price and format score
		for($i = 0; $i < count($searchResult);$i++) {
			$searchResult[$i][image_uri] = CommonValue::getImgUploadPath() . $searchResult[$i][image_uri];
			$searchResult[$i][vip_price] = $searchResult[$i][price] * CommonValue::getVipDiscount();
			$searchResult[$i][score] = round($searchResult[$i][score], 2);
		}
		// paging
		$show = $Page->show();
		$this->assign('page', $show);
		$this->assign($goods->getDataName(), $searchResult);
		//set keywords
		$this->assign('keywords', $keywords);
		//set 3 kinds goods' sort options
		$this->assign('general_goods_sort_options', GeneralGoodsModel::getSortFieldArrayWithHead());
		$this->assign('hotel_room_sort_options', AirplaneTicketModel::getSortFieldArrayWithHead());
		$this->assign('airplane_ticket_sort_options', HotelRoomModel::getSortFieldArrayWithHead());
		//set 3 kinds goods' source place option
		$this->assign('general_goods_source_place', GeneralGoodsModel::getSourcePlaceObjectsArrayWithHead());
		$this->assign('hotel_room_source_place', HotelRoomModel::getSourcePlaceObjectsArrayWithHead());
		$this->assign('airplane_ticket_departure_place', AirplaneTicketModel::getSourcePlaceObjectsArrayWithHead());
		$this->assign('airplane_ticket_arrival_place', AirplaneTicketModel::getArrivalPlaceObjectsArrayWithHead());
		//set hotel suit options
		$this->assign('hotel_room_suit', HotelRoomModel::getHotelRoomSuitArrayWithHead());
		//set airplane carbin options
		$this->assign('airpalne_ticket_carbin', AirplaneTicketModel::getAirplaneTicketCarbinArrayWithHead());
		//set hotest goods
		$hotest = GoodsHelper::getHotestGoods(10);
		for($i = 0; $i < count($hotest);$i++) {
			$hotest[$i][image_uri] = CommonValue::getImgUploadPath() . $hotest[$i][image_uri];
		}
		$this->assign('hotest_goods', $hotest);
		//set if the user is a vip
		$this->assign('is_vip',BuyerHelper::getIsVip($userId));
		
		$this->assign('goods_type', $goods->getType());
		$this->display();
	}

	public function detail() {
		$id = $this->_get('id');
		//if the id is none
		if(!$id) {
			$this->error();
			return;
		}
		$good = GoodsHelper::getBasicGoodsInfoOfId($id);
		$type = GoodsHelper::getGoodsTypeOfId($id);
		//if the id is wrong, no corresponding goods
		if(!$good) {
			$this->error();
			return;
		}
		$userId = $this->_session('uid');
		//add to shopping cart port request
		if (IS_POST) {
			$buyer = M('Buyer');
			//if not a buyer
			if (!$userId || !$buyer->where('uid = '.$userId)->find()) {
				$this->ajaxReturn(0, 'To use shopping cart, you must login as a buyer!', 0);
				return;
			}
			else if(!(D("goods")->getStockById($id) > 0)){
				$this->ajaxReturn(0, 'Sold out!', 0);
				return;
			}
			else{
				$shoppingCart = D('ShoppingCart');
				$shoppingCartRecord = $shoppingCart->where('user_id = '.$userId.' AND good_id = '.$id)->find();
				//exists already, add the count of goods to buy
				if($shoppingCartRecord) {
					$shoppingCart->modifyCount($userId, $id, 'true');
					$this->ajaxReturn(0, "Add succeeded", 1);
					return;
				}
				//no this goods in shopping cart, good_count of 1
				else {
					$data = array(
						'good_id' => $id,
						'user_id' => $userId,
						'good_count' => 1,
					);
					//create succeed
					if ($shoppingCart->create($data)){
						$id = $shoppingCart->add();
						if($id) {
							$this->ajaxReturn(0, "Add succeeded", 1);
							return;
						}
					}
				}
				$this->ajaxReturn(0, "Add failed.", 0);
			}
		}
		//show details of good
		else {
			//add browse history
			if($userId) {
				$browseHistory = D('BrowseHistory');
				$data = array(
					'good_id' => $id,
					'user_id' => $userId,
					'date_time' => time(),
				);
				if ($browseHistory->create($data)){
					$history_id = $browseHistory->add();
				}
			}
			$feedback = D('Feedback');
			$user = D('User');
			//find feedbacks
			$feedbacks = $feedback->where('goods_id=' . $id)->select();
			$feedbacksFull = array();
			//find feedbacks' user
			foreach($feedbacks as $eachFeedback) {
				$userInfo = $user->where('UID=' . $eachFeedback[user_id])->find();
				$newFeedback = array_merge($eachFeedback, array(username => $userInfo[USERNAME]));
				$feedbacksFull = array_merge($feedbacksFull, array($newFeedback));
			}
			//special information about hotel room
			if($type == HotelRoomModel::getType()) {
				$good[date_time] = TimeFormatter::formatTime($good[date_time]);
			}
			//special information about airplane
			else if($type == AirplaneTicketModel::getType()) {
				$good[departure_date_time] = TimeFormatter::formatTime($good[departure_date_time]);
				$good[arrival_date_time] = TimeFormatter::formatTime($good[arrival_date_time]);
			}
			//assign all these data to the webpage
			$this->assign('feedbacks', $feedbacksFull);
			$good[score] = round($good[score], 2);
			$good[image_uri] = CommonValue::getImgUploadPath() . $good[image_uri];
			$good[vip_price] = $good[price] * CommonValue::getVipDiscount();
			//set if the user is a vip
			$this->assign('is_vip',BuyerHelper::getIsVip($userId));
			$this->assign('goods_info', $good);
			$this->assign('goods_type', $type);
			$this->assign('general_goods_type', GeneralGoodsModel::getType());
			$this->assign('hotel_room_type', HotelRoomModel::getType());
			$this->assign('airplane_ticket_type', AirplaneTicketModel::getType());
			$this->display();
		}
	}
	
	public function stockNum() {
		if(IS_POST) {
			$good_id = $this->_post('good_id');
			$this->ajaxReturn(0, D("goods")->getStockById($good_id), 1);
		}
	}

	public function ordergen() {
		//Session info
		$uid = $this->_session('uid');
		$uname = $this->_session('username');
		$is_vip = BuyerHelper::getIsVip($uid);

		//Check identification
		$User = D('Buyer');
		if(!$uid || !$User->where('UID='.$uid)->select()) {
			$this->error('Please login as a buyer first!','__APP__/User/login');
		}

		//Check address
		$addr = D('Address');
		$condition['UID'] = $uid;
		$addr_list = $addr->where($condition)->select();
		//If Buyer has no shipping address
		if(!$addr_list) {
			$this->error('Your do not have any shipping address. 
				Please add one before you place an order', '__APP__/User');
			return;
		}
		if(!D('User')->isAuthenticated($uid)) {
			$this->error('You are no authenticated.
				Please authenticate before purchase.', '__APP__/User');
			return;
		}

		//Show shopping list
		$shopping_cart_list = $this->_post();
		if(!$shopping_cart_list) {
			$this->error('No goods! Please make some purchase.', '__APP__/Purchase/index');
		}
		else {
			//Generate ordercreate interface with group2
			$commodity_list = $shopping_cart_list['good_pairs'];
			$list_count = count($commodity_list) / 2;
			for($i = 0; $i < $list_count; $i++) {
				$goods_list_int[$i]['goods_id'] = $commodity_list[2*$i]['good_id'];
				$goods_list_int[$i]['goods_count'] = $commodity_list[2*$i+1]['good_count'];
				$good = GoodsHelper::getBasicGoodsInfoOfId($goods_list_int[$i]['goods_id']);
				if($is_vip) {
					$goods_list_int[$i]['goods_price'] = CommonValue::getVipDiscount() * $good['price'];
				}
				else {
					$goods_list_int[$i]['goods_price'] = $good['price'];
				}
				// $goods_list_int[$i]['goods_discount'] = CommonValue::getVipDiscount();
			}

			//Generate imcomplete order and get order_id list (int group 2)
			$order_list = R('Order/createorder',array($goods_list_int));
			//Change stock and bought_count
			if($order_list) {
				$Goods = D('Goods');
				for ($i = 0; $i < $list_count; $i++) {
					$goods_id = $goods_list_int[$i]['goods_id'];
					$goods_count = $goods_list_int[$i]['goods_count'];
					if(!$Goods->changeStock($goods_id, -$goods_count)) {
						$this->error('System error! Stock fail to change','__APP__/Purchase');
					}
				}				
			}
			else {
				$this->error('Invalid request!','__APP__/Purchase');
			}

			$order_count = count($order_list);

			$this->assign('order_list', $order_list);
			$this->assign('order_count', $order_count);

			$this->display();
		}
	}

	public function orderinfo() {
		//Session info
		$uid = $this->_session('uid');
		$uname = $this->_session('username');
		//Check identification
		$User = D('Buyer');
		if(!$uid || !$User->where('UID='.$uid)->select()) {
			$this->error('Please login as a buyer first!','__APP__/User/login');
		}
		
		//Show and select shipping address
		$addr = D('Address');
		$condition['UID'] = $uid;
		$addr_list = $addr->where($condition)->select();
		//If Buyer has no shipping address
		if(!$addr_list) {
			$this->error('Your do not have any shipping address. 
				Please add one before you place an order', '__APP__/User');
			return;
		}
		if(!D('User')->isAuthenticated($uid)) {
			$this->error('You are no authenticated.
				Please authenticate before purchase.', '__APP__/User');
			return;
		}
		$this->assign('addr_list', $addr_list);
		
		//Check valid access
		$order_info = $this->_post();
		if(!$order_info) {
			$this->error('No orders! Please make some purchase.', '__APP__/Purchase/index');
		}
		else {
			$Order = D('Orders');
			$OrderGoods = D('OrderGoods');
			$order_count = $order_info['order_count'];
			$total_price = 0;

			//Get order info list
			for($i = 1; $i <= $order_count; $i++) {
				//Get order if
				$order_id = $order_info['order_id_'.$i];
				$order_list[$i]['ID'] = $order_id;
				$order_item = $Order->findorderbyid($order_id);

				//Get order seller
				$order_list[$i]['SELLER'] = $order_item['SELLER'];

				//Get order price
				$order_list[$i]['PRICE'] = $order_item['TOTALPRICE'];

				//Calculate total price
				$total_price += $order_item['TOTALPRICE'];

				//Get goods list for each order
				$goods_list = $OrderGoods->searchbyid($order_id);
				$goods_count = count($goods_list);

				//Get goods info
				for($j = 0; $j < $goods_count; $j++) {
					$goods_id = $goods_list[$j]['GID'];
					$goods_item = GoodsHelper::getBasicGoodsInfoOfId($goods_id);	 
					$order_list[$i]['GOODS'][$j]['PRICE'] = $goods_list[$j]['PRICE'];
					$order_list[$i]['GOODS'][$j]['COUNT'] = $goods_list[$j]['AMOUNT'];
					$order_list[$i]['GOODS'][$j]['URI'] = CommonValue::getImgUploadPath() . $goods_item['image_uri'];
					$order_list[$i]['GOODS'][$j]['NAME'] = $goods_item['name'];
				}
			}
			$this->assign('order_list', $order_list);
			$this->assign('total_price', $total_price);
			$this->assign('order_count', $order_count);

			$this->display();

		}
	}

	public function orderprocess() {
		//Session info
		$uid = $this->_session('uid');
		$uname = $this->_session('username');

		$User = D('Buyer');
		if(!$uid || !$User->where('UID='.$uid)->select()) {
			$this->error('Please login as a buyer first!','__APP__/User/login');
		}

		$order_info = $this->_post();
		$order_count = $order_info['order_count'];

		$Order = D('Orders');
		// generate order
		if(isset($order_info['generate'])) {
			for($i = 1; $i <= $order_count; $i++) {
				$order_id = $order_info['order_id_'.$i];
				$data['ADDRESSID'] = $order_info['addr_sel'];
				$result = $Order->where('ID='.$order_id)->save($data);
			}
			$this->success('Your Order is Generated Successfully!', '__APP__/Order/showorders/');
		}

		//cancel order
		else {
			$OrderGoods = D('OrderGoods');
			for($i = 1; $i <= $order_count; $i++) {
				$order_id = $order_info['order_id_'.$i];
				$condition = array('OID'=> $order_id);
				// $OrderGoods->where($condition)->delete();
				// $Order->delete($order_id);
		        $operations = D('OrderOperation');
		        $operations->addOperation($order_id, "cancel", $uid);

		        $orders=D('Orders');
		        $orders->changeState($order_id, 'canceled');
			}
			$this->success('Your Order is canceled', '__APP__');
		}
	}

	public function comment() {
		$order_id_list = $this->_get();
		$order_id = $order_id_list['oid'];
		$OrderGoods = D('OrderGoods');
		$goods_list = $OrderGoods->searchbyid($order_id);
		$goods_count = count($goods_list);
		if(!$goods_list) {
			$this->error('Order dismissed!', '__APP__/Order/showorders');
		}
		//var_dump($goods_list);
		else {
			for($i = 0; $i < $goods_count; $i++) {
				$goods_id = $goods_list[$i]['GID'];
				$goods_item = GoodsHelper::getBasicGoodsInfoOfId($goods_id);	 
				$goods_info_list[$i] = $goods_item; 
				$goods_info_list[$i]['count'] = $goods_list[$i]['AMOUNT'];
				$goods_info_list[$i]['img_uri'] = CommonValue::getImgUploadPath() . $goods_item['image_uri'];
			}

			$this->assign('order_id', $order_id);
			$this->assign('goods_count', $goods_count);
			$this->assign('goods_info_list', $goods_info_list);
			$this->display();
		}

	}
	public function commentprocess() {
		//Session info
		$uid = $this->_session('uid');
		$uname = $this->_session('username');

		$User = D('Buyer');
		if(!$uid || !$User->where('UID='.$uid)->select()) {
			$this->error('Please login as a buyer first!','__APP__/User/login');
		}
		$comment_info = $this->_post();
		$order_id = $comment_info['order_id'];
		if(!$order_id) {
			$this->error('Invalid access!', '__APP__/Order/showorders');
		}
		else {
			if(isset($comment_info['confirm'])) {
				//Add Feedback
				$Feedback = D('Feedback');
				$goods_count = $comment_info['goods_count'];
				$order_id = $comment_info['order_id'];
				$data['user_id'] = $uid;
				$data['transaction_id'] = $order_id;
				$date = date('Y-m-d H:i:s');
				$data['date_time'] = $date;
				for ($i = 1; $i <= $goods_count; $i++) {
					$data['goods_id'] = $comment_info['goods_id_'.$i];
					$data['score'] = $comment_info['score_'.$i];
					$data['comment'] = $comment_info['comment_'.$i];
					$Feedback->add($data);
				}

				//Update Score
				for ($i = 1; $i <= $goods_count; $i++) {
					$goods_id = $comment_info['goods_id_'.$i];
					$Feedback->score_sale_update($goods_id);
				}
				$this->success('Score and comment successfully!', '__APP__/Order/showorders');
			}
			else {
				$this->sucess('Make Feedback later!', '__APP__/Order/showorders');
			}
		}
	}


	public function recommend() {
		// init
		$id = $this->_session('uid');
		$K = 10;	// for k-nn
		$N = 10;	// recommend N goods
		// get raw data
		$Order = D('Orders');
		$prefix = C('DB_PREFIX');
		$tuples = $Order->field('buyer, gid')->join($prefix.'order_goods ON '.$prefix.'order_goods.OID = '.$prefix.'orders.ID')->select();
		$buyers = D('Buyer')->count();
		$goods = D('Goods')->count();
		// init matrix
		for ($i = 0; $i < $buyers; ++$i) {
			for ($j = 0; $j < $goods; ++$j) {
				$matrix[$i][$j] = 0;
			}
		}
		// matrix form data
		foreach ($tuples as $tuple) {
			++$matrix[$tuple['buyer']][$tuple['gid']];
		}
		// calc distance
		for ($i = 0; $i < $buyers; ++$i) {
			$sum = 0;
			for ($j = 0; $j < $goods; ++$j) {
				// using abs distance
				$sum += abs($matrix[$id][$j] - $matrix[$i][$j]);
			}
			$distance[$sum] = $i;
		}
		krsort($distance);
		print_r($distance);
		// vote
		for ($j = 0; $j < $goods; ++$j) {
			// init voting
			$votes[$j] = - $K * $matrix[$id][$j];
		}
		for ($i = 0; $i < $K; ++$i) {
			for ($j = 0; $j < $goods; ++$j) {
				// voting
				$votes[$j] += $matrix[array_shift($distance)][$j];
			}
		}
		// recommend
		arsort($votes);
		print_r(array_slice($votes, 1, $N));
		$this->assign('' ,array_slice($votes, 1, $N));
		// $this->display();
	}
}
?>
