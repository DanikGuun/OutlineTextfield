Библиотека OutlineTextfield - текстовое поле с обводкой и плавающим(или нет) placeholder
<p>Взаимодействие происходит как со стандартным UITextField</p>
<p>
<p>
Пример
<p/>
<img width="190" alt="image" src="https://github.com/user-attachments/assets/14847b6d-39a1-432d-8cb4-51a3f64d66ee">
<p>
<br>
<i>Новые свойства и их описание:</i><br/>
<p>
<tt>outlineColor: UIColor</tt> - цвет обводки textField<br/>
<tt>placeholderColor: UIColor</tt> - цвет placeholder, когда он внутри текста (не outlined)<br/>
<tt>outlinedPlaceholderColor: UIColor</tt> - цвет placeholder, когда он outlined<br/>
<p>
<tt>lineWidth: CGFloat</tt> - толщина обводки<br/>
<tt>leftTextInset: CGFloat</tt> - отступ текста слева<br/>
<tt>rightTextInset: CGFloat</tt> - отступ текста справа<br/>
<tt>outlineCornerRadius: CGFloat</tt> - радиус скругления углов обводки<br/>
<p>
<tt>placeholderFont: UIFont</tt> - шрифт для placeholder<br/>
<tt>outlinedPlaceholderFont: UIFont</tt> - шрифт для placeholder, когда он outlined<br/>
<p>
<tt>placeholderBehavior: PlaceHolderBehaviour</tt> - поведение placeholder при редактировании <i>(enum ниже)</i><br/>
<p>
  <br>
enum <tt>PlaceHolderBehaviour</tt>{<br>
    <tab>case <tt>floating</tt> - placeholder уплывает при редактировании и остается сверху, если textField не пустой<br>
    case <tt>hide</tt> - placeholder просто скрывается (как в стандартном UITextField)<br>
}<br>

Если вам помогло моё решение - поставьте пожалуйста <tt>Звёздочку</tt>. Это будет лучшая благодарность для меня<br>
<i>email для связи и предложений:</i> bondardanya10@gmail.com
