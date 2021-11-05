# ios-juice-maker
iOS 쥬스 메이커 재고관리 시작 저장소
# Juice Maker
> 쥬스를 만들 때 필요한 타입을 정의하고, 쥬스 주문 및 재고 수정하는 기능 구현하기

### Index
- [기능](#기능)
- [설계 및 구현](#설계-및-구현)
- [Trouble shooting](#trouble-shooting)

---

## 기능
### 쥬스 주문
![orderJuice](https://user-images.githubusercontent.com/60090790/140480409-62519956-4416-44fc-98ba-f5edf9f6213c.gif)

### 재고 수정
![manageStock](https://user-images.githubusercontent.com/60090790/140472779-e212dbad-457b-4f73-8ba7-47e99c3264cb.gif)


---
## 설계 및 구현
#### ViewController
![Simulator Screen Shot - iPhone 12 - 2021-11-05 at 18 00 09](https://user-images.githubusercontent.com/60090790/140485011-ffc39c31-e237-4e09-afa2-fcf18cdacdf8.png)

#### StockViewController
![Simulator Screen Shot - iPhone 12 - 2021-11-05 at 18 00 22](https://user-images.githubusercontent.com/60090790/140484998-1fdd92c2-a54a-4d72-8625-5b062c6c4a74.png)

### 역할 분배
#### struct JuiceMaker
> 주문을 받고, 쥬스를 제조한다

| method              | 설명                                           |
| ------------------- | ---------------------------------------------- |
| `order`             | 과일 재고를 파악한 후 쥬스 제조하기                    |
| `isReadyToMake`     | 쥬스 제조에 필요한 모든 재료가 있는지 확인하기             |
| `isHaveEnoughStock` | 하나의 과일에 대해서 재고가 있는지 확인하기                |
| `make`              | 재료를 차감하며 쥬스를 제조하기                         |

#### class FruitStore
> 과일의 종류와 재고를 가지고 있고, 재고를 관리한다

| method              | 설명                                        |
| -------------       | ------------------------------------------- |
| `manageStock`       | 과일의 재고 인벤토리에 접근해 재고 증감하기             |


#### enum Juice
> 쥬스의 종류와 이름, 쥬스 제조 레시피를 가지고 있다

#### ViewController
> 과일의 현재 재고, 쥬스 주문 버튼, 쥬스 주문 성공 여부를 보여 준다

| method               | 설명                                                         |
| ---------------------------- | ------------------------------------------------------------ |
| `showSuccessAlert`         | 재고가 있을 때 쥬스 제조가 완료되었다는 얼럿을 띄우기 |
| `showFailureAlert`         | 재고가 없을 때 재고를 수정할지 묻는 얼럿을 띄우기 |
| `order`         | 버튼을 통해 주문을 받기 |

#### StockViewController
> 과일의 현재 재고, 재고 수정할 수 있는 화면을 보여 준다 

---
## Trouble Shooting
# Trouble Shooting

문제발생)
**Before**, orderJuice()메서드내에서 쥬스에 필요한 과일재고가 2개이상일 경우에 모두 재고가있을경우엔 정상작동하지만 첫번째 과일은 재고가 있지만 두번째과일이 재고가 없을경우 첫번째 재고가 차감이되는 문제가 발생

해결) 반복문을 최대한 하나로 해결해보려 했으나 방법을 찾지못하여 재고가충분한지확인하는메서드와 재고증감메서드를 분리하여 각 반복문으로 계산 후 주문처리하는 것으로 변경
**Before**

```

    func orderJuice(for menu: Juice) -> Bool {
        var confirmedFruitStock = 0
        let juiceIngredientCounter = menu.recipe.count
        for (fruitName, juiceIngredient) in menu.recipe {
            guard (try? isHaveEnoughStock(fruitName: fruitName, juiceIngredient: Int)) != nil else{
                return false
            }
            confirmedFruitStock += 1
            guard confirmedFruitStock == juiceIngredientCounter, (try? stock.changeFruitStock(fruitName: fruitName, changingNumber: -juiceIngredient)) != nil else {
                continue
            }
        }
        return true
    }

```

**After**

```
    private func isReadyToMake(juice: Juice) -> Bool {
        for (fruit, juiceIngredient) in juice.recipe {
            guard isHaveEnoughStock(of: fruit, for: juiceIngredient) else {
                return false
            }
        }
        return true
    }

    private func make(juice: Juice) {
        for (fruit, juiceIngredient) in juice.recipe {
            fruitStore.manageStock(of: fruit, amount: -juiceIngredient)
        }
    }
```

---

## 해결하지 못한 부분

- View 화면 전환시 segue를 통해 업데이트된 과일재고 데이터전달 (시간부족)
- AutoLayout 설정 (시간부족)
- ViewController의 역할과 JuiceMaker과 FruitStore의 객체간 역할 분배, (문제점: ViewController가 JuiceMaker를 통해 FruitStore의 값을 가져와야하지만 그렇지 못한상황)


---

## 의문점

현재 View에서 다음 View로 데이터전달은 어떻게 해야할까? 데이터전달하는 종류는 Segue, Notifycation, delegation 등등이 존재하는데 이중 어떤걸 선택하는게 좋을것인가?

---

## 진행하며 배운 개념

- UIViewController
- UIAlertViewController, UIAlertAction
- SegueAction
- IBOutlet, IBAction
- UILabel
storyboard의 속성과 연결해줌으로써 값을 전달할 수 있게되는 타입.. 사실 아직잘모르겠따.
- UIBarButtonItem
- ~~Singleton~~ 싱글톤의 장점은 하나의 인스턴스만을 사용하도록 보장할 수있다는 장점이있고 데이터를 사용하는 곳이 명확하고 전역변수로서 사용하기때문에 외부에서 접근이 용이하다.
하지만 장점만 존재하는것은 아니다. 싱글턴을 사용할시 잘활용하면 좋지만 그렇지않으면 의존성을 깊이 유발할 수있다. 하나의 인스턴스로 모든데이터들이 관리가 된다고한다면 예를들어서
이런 경우가 발생할 수있다. fruitStore에서 과일재고를 관리하는 사람이 개수를 잘 알고있는상태에서 누가 물어본다. 바나나재고는 몇개요 ? 라고하면 관리자가 확인하고 네 7개입니다.
라고 말을해주는 찰나에 다른직원이 바나나를 처리하는 일이생겨 재고를 급하게 사용해야해서 실제로는 5개가 있었던것이다. 이렇게 의존성이 발생하게되면 데이터가 꼬일 수있다는 단점이있다.
그렇기때문에 만약에 싱글턴의 장점을 잘 활용하려면 데이터가 어디서접근하고있는지 정확하게 파악을 하고있어야한다는 것이다. 이런점을 인지하고 사용하면 좋을 수 있다.

- private, fileprivate
FruitStore내 fruits프로퍼티에 접근하려면 FruitStore타입내에서만 접근이가능하다.
여길 왜 private으로 설정해야할까 ?
private을 두면 좋은점은 FruitStore타입을 통해서나 FruitStore내부에서만 접근을 할 수있다는것이다.
우리의 요구사항은 JuiceMaker가 FruitStore를 소유한다라는 조건이있었지만 객체지향의 관점에서는 JuiceMaker가 FruitStore에 접근하려면 
FruitStore에서 재고를 JuiceMaker에게 전달해주는식이 객체지향에 더 가깝다는 것.
고로 독립적인 기능을하고 의존성을 줄일 수 있는 것이다. 쥬스메이커는 요구사항에 소유개념이 존재했기때문에 어쩔수없지만 그런 사항이없다고한다면
의존적인것보다 FruitStore가 하는 재고관리에대한 역할을 처리하고 JuiceMaker쪽으로 넘겨주는 코드가 적절해보인다.

- ~~ErrorHandling~~
Error핸들링을 개념적으로는 이해하고있지만 활용에 미숙한것같다. JuiceMaker내에서 Bool반환을 함으로 재고 충분 or 재고불충분 이런식으로 처리를 해주었다.
이런 부분도 두가지 케이스만 존재할때는 Bool타입이 제격이지만 에러종류에는 다양한 처리가 필요로 할 수 있다. 재고가 부족한데 과일이썩어서 그럴 수 있고
주문이 안되는이유를 예로들면 너무나 많은 경우의수가 있을 수 있다는것이다. 막말로 직원이 아프다거나. 휴일이라거나 다양한 이유가 있을수있는데 이런부분에서는 Eror Handling
을 사용하면 적절하고 세부적인 케이스별로 처리를 할 수있다는 장점이있다.

- enum computed Properties
enum의 장점중 하나는 유연하다는 점이있다. 프로젝트를 진행하면서 쥬스주문시 메세지를 띄워야하는 문자열을 사용한다. 하지만 고정적인 문자열을 사용하게되면
하드코딩의 위험이 있다. 내가 이해한바로는 코드는 유연하고 재사용성이 생길 수록 객체지향코드에 가까워져 좋은코드가 되는데 하드코딩이 발생하면 객체지향의 성격과 좀
멀어질 수있다는점을 해결하는데 computed properties를 사용했다.
enum은 case의 rawValue로 값을 가질 수있고 case의 프로퍼티도로 접근하여 값을 가질 수있기때문에 상당히 유연한것같다.
- typealias
String, Int, Double 등등 기본 타입이 변수, 매개변수와 잘어우러지면 가독성이증가하여 사용하였다. 
- Custom Class
UIViewController를 상속받는 클래스는 만든다고해서 Storyboard와 연결이 될 수 있는건 아니다. Identity Inspector내 cuetom class안 class에 UIViewController 
를 지정해주어야 스토리보드. View와 연결이되는것이다
- Message
메서드 끼리 값을 주고받는걸 '메세지'라고 부른다. 객체지향언어 포인트가 메서드끼리 하나의 기능만을 하여 값을 서로 주고받는 독립적인 형태로 구현이되는것인데
메세지를 주고받는 형태의 코드를 작성하면 의존성이 줄어든다.
