# Klaybooks
NFT마켓플레이스 제작 해커톤 - Team#7클레이문고


### Smart Contract[작업 중]

### React 앱 Github 레포지토리[작업 중]

### Team7 : 클레이문고(Klaybooks)

문진선(팀장), 강태호, 박기둥, 이의수, 임혁균

### 프로젝트 주제 : 'NFT 독립출판 서비스'

#### 1.	개요

	- 독립출판시장의 활성화로 누구나 자신만의 책을 출판할 수 있지만, 한정적인 시장에 개인이나 소수의 인원들이 시간과 비용을 들어 직접 기획부터 유통까지 담당하기에는 부담이 큰 단점이 있습니다.

	적은 기회비용으로 누구나 독립출판 서비스를 이용하거나 오프라인 실제 유통전 자신의 컨텐츠를 시험해볼 수 있는 플랫폼 구현이 목표입니다.

#### 2.	프로젝트 목표

*	'NFT독립출판서비스' 프로젝트는 아래와 같은 사항들을 목표로 합니다. :

	* 오프라인 독립출판보다 훨씬 적은 기회비용(시간, 금액, ..etc.)을 통한 '대중적인' 독립출판 서비스를 제공하고자 합니다. 일정량의 수수료만 지불한다면, 누구나 책을 NFT로 발행할 수 있어야 합니다.
  	* "Create to Earn" - 창작자들에게 정당한 보상을 돌려주고자 합니다.
	      현재 브런치나 medium은 컨텐츠 생산자가 아닌 플랫폼이 수익을 독점하는 구조이다. 합리적인 플랫폼 이용비를 지불한다면 컨텐츠 생산자가 수익을 얻어야합니다.
  	* 오프라인으로 유통하기 전, 독자들의 반응을 살펴보는데 적합한 플랫폼을 구현하고자 합니다.
  	* 친구들이나 연인과 같이 공유하고 싶은 추억을 담긴 책이나 앨범으로 쉽게 만들어 블록체인 위에서 보관, 선물할 수 있는 기능을 구현하고자 합니다.

#### 3.	서비스 기능

##### 3.1.	서비스 구성원

- 클레이문고(Klaybooks) 서비스의 구성원을 크게 3가지 그룹으로 나눌 수 있습니다. 
     
	* 작가(Writer) : 클레이 문고에 NFT도서와 같은 컨텐츠를 생성하는 생산자. 
	* 독자(Reader) : 스마트 컨트랙트에 민팅되어 있는 NFT도서를 대여하거나 구매하는 소비자. 
	* 플랫폼 중개자(Router) : 작가가 생산한 컨텐츠를 독자에게 잘 전달될 수 있도록 플랫폼을 유지보수하거나 기능을 구현하는 역할을 담당. 그에 대한 보수로 플랫폼 내부에서 발생되는 거래에 대해 일정량의 수수료를 보상으로 요구한다.

##### 3.2. NFT 민팅

* '작가'는 자신의 컨텐츠(주로 PDF파일)를 클레이문고 스마트컨트랙트에 NFT를 생성하여 대여서비스, 소유권 판매 할 수 있습니다.
* NFT 민팅시 컨텐츠 미리보기 이미지, 컨텐츠 설명을 위한 텍스트, 소유권판매비용을 설정할 수 있습니다.
* 민팅된 NFT의 최초 소유권은 민팅한 '작가'에게 있고, 소유권이 있다면 자신의 개인지갑으로 옮기거나 타인에게 소유권을 양도할 수 있습니다.
* 실제 컨텐츠는 분산화 웹 저장소(IPFS)에 저장되며, NFT에는 컨텐츠주소(CID)가 저장되어 소유자나 대여자만 CID를 호출하여 컨텐츠를 열람할 수 있습니다.


##### 3.3. NFT 대여

* '독자'는 클레이문고 스마트컨트랙트 내부에 민팅되어있는 NFT를 일정기간동안 대여할 수 있습니다.
* 클레이문고 스마트컨트랙트는 '독자'의 대여요청을 받으면 '독자'의 지갑에 요구되는 대여비가 있는지 확인하고 대여비가 지불되면 대여를 자동으로 승인해줍니다.
* 대여기간동안 '독자'는 NFT 내부에 저장되었는 CID를 호출하여 컨텐츠를 열람할 수 있습니다.
* 대여기간은 3일이며, 대여기간이 만료되면 더이상 CID를 호출 할 수 없습니다.
* 대여시 '독자'에게는 CID를 호출할 수 있는 권한만 부여된것이기에 개인지갑으로 옮기거나 타인에게 소유권을 양도하는 등 소유권자의 행위를 할 수 없습니다.
* NFT도서의 대여가 시작되면 대여기간 만료전까지 NFT 소유권자는 해당 NFT를 자신의 개인지갑으로 옮기거나 타인에게 소유권을 양도, 판매할 수 없습니다. 
* 대여비는 'Gas Fee' , '컨텐츠 이용비' , '플랫폼 이용비' 를 합산한 금액이며 Klay로 지불합니다.
* 컨텐츠 이용비는 '작가'에게 전달되며 플랫폼 이용비는 '플랫폼 중개자'에게 전달됩니다.

##### 3.4. NFT 소유권 구매

* '독자'는 클레이문고 스마트컨트랙트 내부에 민팅되어있는 NFT중 소유권을 구매할 수 있습니다.
* 소유권 구매비용은 'Gas Fee', '작가가 설정한 판매비용', '플랫폼 이용비'를 합산한 금액이며 Klay로 지불합니다.
* '작가'가 설정한 판매비용은 '작가'에게로 전달되고, 플랫폼 이용비는 '플랫폼 중개자'에게 전달됩니다.
* 구매한 NFT는 '독자'의 개인지갑으로 이동되고 '독자'가 자유로이 열람하거나 타인에게 양도할 수 있습니다.

##### 3.5. 플랫폼 중개자의 의무
	
* 컨텐츠 생산자가 자신의 작품을 많은 독자들이 열람하거나 소비할 수 있도록 소비자에게 플랫폼을 적극적으로 홍보해야합니다.
* 컨텐츠 소비자가 양질의 컨텐츠를 열람할 수 있도록 컨텐츠 생산자에게 플랫폼을 적극적으로 홍보해야합니다.
* 원활한 서비스가 제공될 수 있도록 플랫폼 유지보수를 수행해야 합니다.
* '독자'와 '작가'에게 요구한 플랫폼 이용비를 작가와 독자 등 이용자 유치와 서비스 유지보수를 위해 사용함으로서 수수료에대한 정당성을 입증해야합니다.
