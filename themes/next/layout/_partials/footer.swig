<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

<div class="theme-info">
	<span class="with-love"><i class="fa fa-cogs"></i><span style="font-size: 15px;font-weight: 500;">&nbsp;&nbsp;&nbsp;All   Rights   Reserved</span></span>
</div>


{% if theme.copyright %}
<!--
<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="https://hexo.io">Hexo</a>') }}
</div>
-->

<!--
<script async src="//dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
本站总访问量 <span id="busuanzi_value_site_pv"></span> 次&nbsp&nbsp&nbsp&nbsp|&nbsp&nbsp&nbsp&nbsp   
-->

<!--
<div class="theme-info">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
    NexT.{{ theme.scheme }}
  </a>
</div>
-->

{% endif %}
